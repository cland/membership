package cland.membership

import cland.membership.security.Person
import cland.membership.lookup.Keywords;
import java.util.Date;

import org.joda.time.*

class Visit {
	transient cbcApiService
	transient springSecurityService
	transient groupManagerService
	static attachmentable = true
	//Date visitDate
	Date starttime
	Date endtime
	Date timerCheckPoint
	String status
	String contactNo
	String photoKey
	Integer selectedHours
	Office office
	String visitNo
	static belongsTo = [child:Child]
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	Integer startweek
	Integer startmonth
	Integer startyear
	Integer startday
	Keywords promotion
	
	static transients = ["createdByName","lastUpdatedByName","visitPhotoId",
		"durationDays","durationHours","durationMinutes","durationText","totalMinutes",
		"isCancelled","isCompleted","isActive","visitHours"]
    static constraints = {
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		contactNo nullable:true
		endtime nullable:true
		photoKey nullable:true
		selectedHours nullable:true
		office nullable:true
		promotion nullable:true
    }
	static mapping = {
		startday formula:'DAYOFMONTH(starttime)'
		startweek formula: 'WEEK(starttime)'
		startmonth formula: 'MONTH(starttime)'
		startyear formula: 'YEAR(starttime)'				
		}
	def beforeInsert() {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId	
		timerCheckPoint = starttime	
		if(contactNo == null || contactNo == ""){
			contactNo = child?.parent?.person1?.mobileNo
		}
		if(selectedHours == null) selectedHours = 1  //default of 1 hour
	}

	def beforeUpdate() {
		lastUpdatedBy = groupManagerService.getCurrentUserId()
	}
	def toMap(params = null){
		return [id:id,
			child:[id:child.id,
				person:child?.person?.toMap(),
				accessno:child?.accessNumber,
				comments:child?.comments,
				medical:child?.medicalComments,
				fullaccessnumber:child?.fullAccessNumber,
				parent:[
					id:child?.parent?.id,
					person1:child?.parent?.person1?.toMap(),
					person2:child?.parent?.person2?.toMap(),
					membershipno:child?.parent?.membershipNo,
					clienttype:child?.parent?.clientType,
					comments:child?.parent?.comments,
					relationship:child?.parent?.relationship,
					partnercontract:PartnerContract.findByParent(child?.parent)?.toMap()
					]
				],			
			date:starttime?.format("dd MMM yyyy"),
			startdatetime:starttime,
			starttime:starttime?.format("dd MMM yyyy HH:mm"),
			endtime:endtime?.format("dd MMM yyyy HH:mm"),
			enddatetime:endtime,
			status:status,
			visitno:visitNo,
			contactno:contactNo,
			createdbyname:getCreatedByName(),
			creatoroffice:getCreatorOffice(),
			lastupdatedbyname:getLastUpdatedByName(),
			photokey:photoKey,
			visitphotoid:visitPhotoId,
			duration:[
				text:getDurationText(),
				days:getDurationDays(),
				hours:getDurationHours(),
				minutes: getDurationMinutes(),
				selectedhours: selectedHours,
				totalminutes:getTotalMinutes(),
				businesshours:getVisitHours()
				],			
			coupon:cbcApiService.findCouponFor(this)?.toReportMap(),
			office:[id:office?.id,name:office?.name,code:office?.code],
			params:params]
	}
	def toAutoCompleteMap(){		
		return [id:id,
		label:starttime?.format("dd-MMM-yyyy") + " " + starttime?.format("HH:mm") + " to " + endtime?.format("HH:mm") + " | " + status,
		value:id,
		child:(this==null?Child.get(id):this),
		photokey:photoKey,
		category:(status==null?"Unknown":status)]
	}
	def reportMap(){
		return [id:id,
		datestring:starttime?.format("dd-MMM-yyyy"),
		year :startyear,
		month:startmonth,
		day:startday,
		week:startweek,
		office:[id:office?.id,name:office?.name,code:office?.code],
		businesshours:getVisitHours(),
		clienttype:[id:child?.parent?.clientType?.id,
			name:child?.parent?.clientType?.name,
			label:child?.parent?.clientType?.label],
		coupon:cbcApiService.findCouponFor(this)?.toReportMap()]
	}
	String toString(){
		return starttime?.format("dd-MMM-yyyy") + " " + starttime?.format("HH:mm") + " to " + endtime?.format("HH:mm")
	}
	String getCreatedByName(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.toString())
	}
	String getLastUpdatedByName(){
		Person user = Person.get(lastUpdatedBy)
		return (user==null?"unknown":user?.toString())
	}
	
	String getCreatorOffice(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.office)
	}
	Integer getDurationDays(){
		return getDurationPeriod().getDays()
	}
	Integer getDurationHours(){
		return getDurationPeriod().getHours()
	}
	Long getTotalMinutes(){
		return (getDurationDays() * 1440) + (getDurationHours() * 60) + getDurationMinutes() 
	}
	Integer getDurationMinutes(){
		return getDurationPeriod().getMinutes()
	}	
	String getDurationText(){
		Period period = getDurationPeriod()		
		return period.getHours() + " hrs " + period.getMinutes() + " mins" 
	}
	Period getDurationPeriod(){
		def _sdate = starttime
		if(!_sdate) _sdate = dateCreated
		def _todate = endtime
		if(!_todate) _todate = _sdate
		
		DateTime _frm = new DateTime(_sdate)
		DateTime _to = new DateTime(_todate)
		
		if(_frm.isAfter(_to)) _to = _frm
		Duration duration = new Interval(_frm, _to).toDuration();
		// Convert to Period
		Period period = duration.toPeriod();
		return period
	}
	Long getVisitHours(){
		Settings settingsInstance = Settings.list().first()
		return getVisitHours(settingsInstance?.mincutoff,settingsInstance?.minmodulo)
	}
	Long getVisitHours(Integer cutoffMinutes,Integer modulo){
		if(cutoffMinutes == null) cutoffMinutes = 12
		if(modulo == null) modulo = 60
		
		Integer hrs = (totalMinutes/modulo)
		Integer mod = totalMinutes % modulo
		if(mod >= cutoffMinutes) hrs++
		return hrs

	}
	/**
	 * To ensure that all attachments are removed when the "owner" domain is deleted.
	 */
	transient def beforeDelete = {
		withNewSession{
		  removeAttachments()
		}
	 }
	Long getVisitPhotoId(String key=null){
		Long pid = null
		if(this.attachments?.size() > 0){
			def tmp = this.attachments[0]
			pid = tmp?.id
		}
		return pid
	}
	boolean getIsCompleted(){
		return status.equalsIgnoreCase("Complete")
	}
	boolean getIsCancelled(){
		return status.equalsIgnoreCase("Cancelled")
	}
	boolean getIsActive(){
		return (!getIsCompleted() & !getIsCancelled())
	}
} //end class
