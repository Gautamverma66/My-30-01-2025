import { LightningElement } from 'lwc';

export default class AttendanceCalendar extends LightningElement {
    
    currentDate = new Date();
    daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat','Sun'];
    calendarDays = [];

    // Get the current month and year for the header
    get currentMonthYear() {
        const options = { year: 'numeric', month: 'long' };
        return this.currentDate.toLocaleDateString('en-US', options);
    }

    // Get the current month and year for the header
    get currentMonthYear() {
        const options = { year: 'numeric', month: 'long' };
        return this.currentDate.toLocaleDateString('en-US', options);
    }

    // Generate the calendar for the current month
    getCalendarDays() {
        // Get the first day of the current month
        const firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1);
        // Get the day of the week for the first day (0 = Sunday, 1 = Monday, etc.)
        let startDay = firstDayOfMonth.getDay();

        // Adjust so that Monday is the first day (if Sunday is 0, Monday becomes 1, etc.)
        if (startDay === 0) {
            startDay = 7; // If it's Sunday (0), we make it 7 to represent the end of the week (Sunday)
        }

        const lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0);
        const totalDays = lastDayOfMonth.getDate();

        let days = [];

        // Add empty slots before the first day of the month
        for (let i = 1; i < startDay; i++) {
            days.push({
                date: '',
                status: '',
                prsent:false,
                absent:false,
                noDay:true // Default status is absent
            });
        }

        // Add the actual days of the month
        for (let i = 1; i <= totalDays; i++) {
            days.push({
                date: i,
                status: 'Present', // Default status is absent
                prsent:true,
                absent:false,
                noDay:false
            });
        }

        // Add empty slots after the last day of the month
        const totalSlots = days.length;
        const endDay = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), totalDays).getDay();
        for (let i = endDay + 1; i <= 6; i++) {
            days.push({
                date: '',
                status: '', // Default status is absent
                prsent:false,
                absent:false,
                noDay:true
            });
        }

        this.calendarDays = days;
    }

    // Navigate to the previous month
    handlePreviousMonth() {
        this.currentDate.setMonth(this.currentDate.getMonth() - 1);
        this.getCalendarDays();
    }

    // Navigate to the next month
    handleNextMonth() {
        this.currentDate.setMonth(this.currentDate.getMonth() + 1);
        this.getCalendarDays();
    }

    // Handle attendance status change
    handleAttendanceClick(event) {
        const clickedDate = event.target.dataset.date;
        const clickedStatus = event.target.dataset.status;

        // Toggle between Present and Absent
        const newStatus = clickedStatus === 'Present' ? 'Absent' : 'Present';
        
        // Find the day in the calendarDays array and update the status
        const dayToUpdate = this.calendarDays.find(day => day && day.date == clickedDate);
        if (dayToUpdate) {
            dayToUpdate.status = newStatus;
        }
        
        // Re-render the calendar
        this.getCalendarDays();
    }

    // On initialization, get the current month calendar days
    connectedCallback() {
        this.getCalendarDays();
    }

    isPresent(status) {
        return status == 'Present' ? true : false;
    }
    handleSourceChange(event){
        let clickedButton = event.currentTarget;
        let allButtonsInGrp = this.refs.dataViewBtnGrp.children;
        for (let btn of allButtonsInGrp) {
            btn.variant = 'neutral';
        }
        clickedButton.variant = 'brand';
    }
}