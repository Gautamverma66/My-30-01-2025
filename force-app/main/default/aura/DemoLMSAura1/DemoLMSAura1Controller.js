({
    handleClick: function(cmp, event, helper) {
        console.log('--DemoLMSAura1 handleClick ---');
       
        var payload = {
            source: 'Aura',
            messageBody: cmp.get('v.messageText')
        };
        cmp.find("myChannnel").publish(payload);
    }
})