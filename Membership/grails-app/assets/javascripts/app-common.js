function getCheckedValues(fieldname, vtype,hidden){
	
	if(hidden == undefined) hidden = "";
    var values = [ ]
    $("input" + hidden + "[name='" + fieldname + "']:checked").each(function() {
    	
        var el = $(this);
        if(vtype=="text" || vtype == "t"){
        	values.push(el[0].nextSibling.nodeValue);                                              
        }else{
        	values.push($(this).val());
        }
     });
	
     return values;
} //end func

function setAllRadio(group,value,checked){
	$(group).each(function() {
		var el = $(this)        
        if(el.val() == value){           
          el.prop("checked",checked)
        } 	
    });
}
function printableTabs() {
	$("#tabs").each(function() {
		var tabsforPrint = "";
		$(this).find(".ui-tabs-nav li a").each(function() {
			tabsforPrint = tabsforPrint + "<h2>" + $(this).html();
			+"</h2><br />";
			var a = $(this).prop('href');
			tabsforPrint = tabsforPrint + $(a).html() + "<br />";
			
		});
		if(tabsforPrint != "") $(this).html(tabsforPrint);
	});
} //end function printableTabs()

function setStyle(frmstyle,tostyle){
	var lnk = ($("link[media=screen]").prop("href"));
	$("link[media=screen]").prop({href : lnk.replace(frmstyle,tostyle)});
}
function printFriendly(on,alltabs){
	if(on){
		if(alltabs) printableTabs();
		setStyle("main.css","print.css")
	}else{
		setStyle("print.css","main.css")
	}
}
function printPage(alltabs){
	if(alltabs) printableTabs();
	window.print();
}
function onChangeCompany(_tab){
	var id = $("#company").val()
	var lnk = document.location.href
	lnk = lnk.substring(0,lnk.indexOf("?"))
	document.location.href = lnk + "?company.id=" + id + "&tab=" + _tab
}
function onChangePerson(_tab){
	var id = $("#person").val()
	var lnk = document.location.href
	lnk = lnk.substring(0,lnk.indexOf("?"))
	document.location.href = lnk + "?person.id=" + id + "&tab=" + _tab
}
function getCurrentTabText(){
	return $("#tabs ul.ui-tabs-nav li.ui-tabs-selected").text()
}
function getCurrentTabLink(){
	return $("#tabs ul.ui-tabs-nav li.ui-tabs-selected a").prop("href")
}

var cbc_datepickers = {
		reset_picker : function resetPicker(picker_id,altfield_id, type){
			$("#" + picker_id).multiDatesPicker('resetDates',type);
			$("#" + altfield_id).prop("value","")
		},
		init_datepicker : function initDatePicker(picker_id,altfield_id, frmdate, todate){
			var el = $("#" + picker_id)
			var altEl = $("#" + altfield_id)
			var datelist = altEl.prop("value")
			if(!frmdate) frmdate="+0";
			if(!todate) todate="+3M +5D";
			el.multiDatesPicker({
				dateFormat: "yy-mm-dd",
				altField: '#' + altfield_id,			
				altFormat:"yy-mm-dd",
				minDate:frmdate,
				maxDate:todate
				//beforeShowDay: $.datepicker.noWeekends
				//maxPicks: 1		
			});
			if(datelist) {
				altEl.prop("value",datelist)
				datelist = datelist.split(",");			
				el.multiDatesPicker('addDates',datelist);
			}	
		},
		init_datepicker_single_future : function initDatePickerSingleFuture(picker_id,fmt, frmdate, todate){
			var el = $(picker_id)
			var datelist = el.prop("value")
			if(!frmdate) frmdate="+0";
			if(!todate) todate="+3M +5D";
			el.multiDatesPicker({
				dateFormat: fmt,
				minDate:frmdate,
				maxDate:todate,
				maxPicks: 1
			});

			if(datelist) {
				el.prop("value",datelist)
				datelist = datelist.split(",");			
				el.multiDatesPicker('addDates',datelist);
			}
	
			
		},init_datepicker_single_past : function initDatePickerSinglePast(picker_id,fmt,frmdate,todate){
			var el = $(picker_id)
			var datelist = el.prop("value")
			if(!frmdate) frmdate="-100y";
			if(!todate) todate="+0";
			$(picker_id).multiDatesPicker({
				dateFormat: fmt,
				maxDate:todate,
				maxPicks: 1
			});

			if(datelist) {
				el.prop("value",datelist)
				datelist = datelist.split(",");			
				el.multiDatesPicker('addDates',datelist);
			}	
		},
		init_datepicker_single_dob : function initDatePickerSingleDob(picker_id,fmt,frmdate,todate){
			var el = $(picker_id)
			var datelist = el.prop("value")
			if(!frmdate) frmdate="-100y";
			if(!todate) todate="+0";
			$(picker_id).multiDatesPicker({
				dateFormat: fmt,
				maxDate:todate,
				defaultDate: "-18y",
				maxPicks: 1
			});

			if(datelist) {
				el.prop("value",datelist)
				datelist = datelist.split(",");			
				el.multiDatesPicker('addDates',datelist);
			}	
		},
		
		init_datepicker_single_standard : function initDatePickerSingleStandard(picker_id,fmt,frmdate,todate,default_date){
			var el = $(picker_id)
			var datelist = el.prop("value")
			if(!frmdate) frmdate="-100y";
			if(!todate) todate="+0";
			if(!default_date) default_date="+0"
			$(picker_id).multiDatesPicker({
				dateFormat: fmt,
				maxDate:todate,
				defaultDate: default_date,
				maxPicks: 1
			});

			if(datelist) {
				el.prop("value",datelist)
				datelist = datelist.split(",");			
				el.multiDatesPicker('addDates',datelist);
			}	
		}		
} //end cland_datepicker

var cbc_location = {
		load_districts: function comboboxDistricts(data,field_id,subfields,defaultValue,callback){			
			this.combobox_options(data,field_id,"--select district--","",true,subfields,defaultValue,callback)			
		},		
		combobox_options: function c_options(data,combobox_id,select0name,select0value,refresh,subfields,defaultValue, callback){			
			var _el = $("#" + combobox_id);
			if(refresh) _el.empty();			
			if(!$.isEmptyObject(data)){
				_el.append("<option value='" +select0value + "'>" + select0name + "</option>");
				$.each(data,function(index,item){
					var _selected = "";
					if(item.id.toString()==defaultValue) _selected = "selected";
					_el.append("<option value='" +item.id + "' " + _selected + ">" + item.name + "</option>");				
				});
			}else{
				_el.append("<option value=''>-- No options found --</option>");
				//set reset all sub options
				this.reset_options(subfields)
			}
			 var func = (typeof callback == 'function') ?  callback : eval(callback);
			if(callback != null & callback != "") {
				func(data,combobox_id,select0name,select0value,refresh,subfields,defaultValue)
			}
		},
		reset_options: function r_options(subfields){	
			var _f = subfields.split(",")
			$.each(_f,function(index,value){
				$("#" + value).empty().append("<option value=''>--</option>");
			})
		},
		current: {
			country:'0',
			region:'0',
			district:'0',
			municipality:'0',
			mainplace:'0',
			suburb:'0'
		}
} //end location helper namespace
