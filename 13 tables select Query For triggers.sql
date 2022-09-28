select top 1* from UI.RadioButtonUIElement
select * from Trgr.RadioButtonUIElement where UIElementID = 176400
select * from cdc.UI_RadioButtonUIElement_CT

select top 1* from UI.RegexLibrary
select * from Trgr.RegexLibrary
select * from cdc.UI_RegexLibrary_CT
Set Identity_insert UI.RegexLibrary Off

insert into UI.RegexLibrary values (2,'time','^(((0?[1-9]|1[012])/(0?[1-9]|1\d|2[0-8])|(0?[13456789]|1[012])/(29|30)|(0?[13578]|1[02])/31)/(19|[2-9]\d)\d{2}|0?2/29/((19|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(([2468][048]|[3579][26])00)))$'
,'date',1,'njadhav','2022-09-27',null,null,'invalid data format','HH-MI-SS','24-24-24',null,null,null,null)

select top 1* from UI.RepeaterKeyFilter
--select * from Trgr.RepeatterKeyFilter
select * from cdc.UI_RepeaterKeyFilter_CT

select * from UI.RepeaterKeyUIElement
select * from Trgr.RepeaterKeyUIElement where UIElementID = 176385
select * from cdc.UI_RepeaterKeyUIElement_CT
Exec [UI].[SpDmlRepeaterKeyUIElement]

insert into UI.RepeaterKeyUIElement values (176399,176385,null,0,0,null)
delete from UI.RepeaterKeyUIElement where UIElementID = 176385

select * from UI.RepeaterUIElement where UIElementID = 176403
select * from Trgr.RepeaterUIElement where UIElementID = 176404
select * from cdc.UI_RepeaterUIElement_CT
delete from cdc.UI_RepeaterUIElement_CT where UIElementTypeID in (7,9)
Exec [UI].[SpDmlRepeaterUIElement]

insert into UI.RepeaterUIElement values(176404,7,3,2,null,0,0,0,1,1,0,0,1,0,0,0,'local Header Firing',null,0,0,null,0)
update UI.RepeaterUIElement set UIElementTypeID = 9 where UIElementID = 176403
delete From UI.RepeaterUIElement where UIElementID = 176403

select top 1* from UI.RepeaterUIElementProperties
select * from cdc.UI_RepeaterKeyUIElement_CT


select * from UI.[Rule]
select * from Trgr.[Rule]
select * from cdc.UI_Rule_CT
exec UI.SpDmlRule

insert into UI.[Rule] values ('enable test rule','enable this field',1,null,null,'rachna','2022-09-27',null, null,0,0,null,0,null,0,0,
null,null,null,null,null,null,0,1,2408,1,null,null,null,null)

select * from UI.SectionUIElement
select * from Trgr.SectionUIElement where UIElementID = 176399
select * from cdc.UI_SectionUIElement_CT
delete from cdc.UI_SectionUIElement_CT
exec UI.SpDmlSectionUIElement

insert into UI.SectionUIElement values(176399,9,1,3,null,null,null,0,0,null)
update UI.SectionUIElement set UIElementTypeID = 10 where UIElementID = 176399
delete from UI.SectionUIElement where UIElementID = 176399

select * from UI.[Status]
select * from Trgr.[Status]
select * from cdc.UI_Status_CT
insert into UI.[Status] values (4,'complete','Admin','2022-26-09' , null,null,1,null,null,null,null) 


select * from UI.TabUIElement
select * from Trgr.TabUIElement where UIElementID = 176398
select * from cdc.UI_TabUIElement_CT
delete from cdc.UI_TabUIElement_CT
exec UI.SpDmlTabUIElement

insert into UI.TabUIElement values(176398,8,0,3,null,0,0,null)
update UI.TabUIElement set UIElementTypeID = 10 where UIElementID = 176398
delete from UI.TabUIElement where UIElementID = 176398

select * from UI.TargetProperty
select * from Trgr.TargetProperty
select * from cdc.UI_TargetProperty_CT
delete from cdc.UI_TargetProperty_CT
exec UI.SpDmlTargetProperty

insert into UI.TargetProperty values ('Negative error',null,0,0,null)
update UI.TargetProperty set IsMigrated = 1 where TargetPropertyID = 15
delete from UI.TargetProperty where TargetPropertyID = 15

select * from UI.TargetRepeaterKeyFilter
--select * from Trgr
select * from cdc.UI_TargetRepeaterKeyFilter_CT

select top 1* from UI.TargetRepeaterResultKeyFilter
--select * from
select * from cdc.UI_TargetRepeaterResultKeyFilter_CT




