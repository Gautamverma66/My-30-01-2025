({
	userDetails : function(component, event, helper) {
		console.log('js');
		var action=component.get("c.fetchUserDetails");
		console.log('js1')
		action.setCallback(this, function(response) {
            console.log('start1 js2');
            var state = response.getState();
            console.log('start1 js3',state);
            if (state === "SUCCESS") {
                console.log('start1 js4');
                var fileList = response.getReturnValue();
               component.set("v.userName",fileList[0]);
			   component.set("v.userEmail",fileList[1]);
			   component.set("v.userPic",fileList[2]);
            }
			else if(state == "ERROR"){
				var errors = response.getError();                       
					
				   console.log(errors[0].message);
			}
			
		});
		$A.enqueueAction(action);
	}
})