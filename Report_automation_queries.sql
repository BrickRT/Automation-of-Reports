# Weekly Comparison
select count(distinct(case when um.custom_user_id is null then ifnull(um.device_id, '')else concat('c-',um.custom_user_id) end)) as user_count,
count(1) sessioncount,sum(if(ut.exception_type = 1, 1, 0)) crash_session_count,
sum(if(ut.exception_type = 2, 1, 0)) anr_session_count,
sum(ifnull(ut.is_ragetap, 0)) rage_session_count
from user_tasks ut
join user_tasks_metadata um on ut.id = um.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8' and ut.platform = 2 and ut.created_at between '2022-10-09 18:30:00' and '2022-10-16 18:30:59';



# Page - Overview

-- Weekly Stats

select count(distinct(case when um.custom_user_id is null then ifnull(um.device_id, '')else concat('c-',um.custom_user_id) end)) as user_count,
count(1) sessioncount,sum(if(ut.exception_type = 1, 1, 0)) crash_session_count,
sum(if(ut.exception_type = 2, 1, 0)) anr_session_count,
sum(ifnull(ut.is_ragetap, 0)) rage_session_count
from user_tasks ut
join user_tasks_metadata um on ut.id = um.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' and ut.platform = 1 and ut.created_at between now() - interval 7 day and now();


-- Daywise Users count

select ut.created_at, count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from user_tasks_metadata as utm
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' 
and ut.platform = 1 and ut.created_at between now() - interval 7 day and now() - interval 6 day
union
select ut.created_at, count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from user_tasks_metadata as utm
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' 
and ut.platform = 1 and ut.created_at between now() - interval 6 day and now() - interval 5 day
union
select ut.created_at, count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from user_tasks_metadata as utm
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' 
and ut.platform = 1 and ut.created_at between now() - interval 5 day and now() - interval 4 day
union
select ut.created_at, count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from user_tasks_metadata as utm
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' 
and ut.platform = 1 and ut.created_at between now() - interval 4 day and now() - interval 3 day
union
select ut.created_at, count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from user_tasks_metadata as utm
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' 
and ut.platform = 1 and ut.created_at between now() - interval 3 day and now() - interval 2 day
union
select ut.created_at, count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from user_tasks_metadata as utm
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' 
and ut.platform = 1 and ut.created_at between now() - interval 2 day and now() - interval 1 day
union
select ut.created_at, count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from user_tasks_metadata as utm
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' 
and ut.platform = 1 and ut.created_at between now() - interval 1 day and now();

-- App launch stats

select  round((sum(total_time)/sum(session_count))/1000,3) avg,
round((sum(case app_launch_type when 'HOT' then total_time else 0 end)/sum(case app_launch_type when 'HOT' then session_count else 0 end))/1000,3) hot_avg,
round((sum(case app_launch_type when 'COLD' then total_time else 0 end)/sum(case app_launch_type when 'COLD' then session_count else 0 end))/1000,3) cold_avg
from ue_summary.summary_v2_app_launch_2619 asp
JOIN unique_app_version up ON asp.app_version_id = up.id
where asp.app_id = 2619
and asp.platform = 1
and asp.time_scope between now() - interval 7 day and now()
and asp.app_version_id = 21536
and app_launch_type is not null
group by up.version
having hot_avg is not null or cold_avg is not null
order by avg desc;

-- Top Network Type

select unt.name , count(ut.id)  as count
from user_tasks as ut
join user_tasks_metadata as utm on utm.user_task_id = ut.id
join unique_network_type as unt on unt.key = ut.network_type
where ut.app_id = 2619 and ut.created_at between now() - interval 7 day and now() and ut.platform = 1  and utm.app_version_id = 21536
group by unt.name
order by count desc;

             /*       select up.key id, 
                            sum(asp.full_count) value,
                            up.name as name
                       from ue_summary.summary_v2_network_type_2619 asp
                       join unique_network_type up on asp.property_master_id = up.key
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by up.key, up.name
                     having value > 0
                      order by value desc
                      limit 10;*/
          
          
          
-- Funnel Conversion

select * from funnel_settings where app_id = 2619;

select * from ue_summary.summary_funnel_1175 where seq_no = 3 and created_at between now() - interval 7 day and now();

select fs.name , 
		   sum(if(sf.seq_no = 1, 1, 0)) as first_seq_value,
           sum(if(sf.seq_no=3,1, 0)) as last_seq_value
from  ue_summary.summary_funnel_1175 as sf 
join funnel_settings as fs on fs.id = sf.funnel_id
where  sf.created_at between now() - interval 7 day and now()
union
select fs.name , 
		   sum(if(sf.seq_no = 1, 1, 0)) as first_seq_value,
           sum(if(sf.seq_no = 2, 1, 0)) last_seq_value
from  ue_summary.summary_funnel_1176 as sf 
join funnel_settings as fs on fs.id = sf.funnel_id
where  sf.created_at between now() - interval 7 day and now()
union
select fs.name , 
		   sum(if(sf.seq_no = 1, 1, 0)) as first_seq_value,
           sum(if(sf.seq_no = 3, 1, 0)) last_seq_value
from  ue_summary.summary_funnel_1178 as sf 
join funnel_settings as fs on fs.id = sf.funnel_id
where  sf.created_at between now() - interval 7 day and now();


-- Top OS Version
 
select uov.version, count(ut.id) as count
from user_tasks as ut
join user_tasks_metadata as utm on utm.user_task_id = ut.id
join unique_os_version as uov on uov.id = utm.os_version
where ut.app_id = 2619 and ut.created_at between now() - interval 7 day and now() and ut.platform = 1 and utm.app_version_id = 21536
group by uov.version
order by count  desc
limit 10;  


           /*          select up.id id, 
                            sum(asp.full_count
                                 
                               ) value,
                            up.version name
                       from ue_summary.summary_v2_os_version_2619 asp
                       join unique_os_version up on asp.property_master_id = up.id
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by up.id, up.version
                     having value > 0
                      order by value desc
                     limit 10; */
                     
                     
-- App versions Value

select uav.version , count(ut.id) as counts 
from unique_app_version as uav 
join user_tasks_metadata as utm on uav.id = utm.app_version_id 
join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.platform = 1 and ut.created_at between now() - interval 7 day and now()
group by uav.version
order by counts desc;

   /*                  select uav.id id,
                            sum(case ", p_exception_type, "
                                   when 0 then asp.session_count
                                   when 1 then asp.crash_session_count
                                   else asp.anr_session_count
                                end
                               ) value,
                            uav.version name
                       from ue_summary.summary_sessions_daily_2619 asp
                       join unique_app_version uav ON asp.app_version_id = uav.id
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by uav.id, uav.version
                     having value > 0
                      order by value desc
                      limit 10; */




# Page - Crash

-- Crash Stats

select sum(if(ut.exception_type = 1, 1, 0)) Total_crash, 
count(distinct(case when um.custom_user_id is null then ifnull(um.device_id, '')else concat('c-',um.custom_user_id) end)) impacted_crash_users
from user_tasks ut
join user_tasks_metadata um on ut.id = um.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' and ut.platform = 1 and ut.exception_type = 1 and ut.created_at between now() - interval 7 day and now();

/*
select count(ut.id) as Total_Crash,
count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '') 
					else utm.custom_user_id end)) as impacted_crash
from user_tasks as ut 
join user_tasks_metadata as utm on utm.user_task_id = ut.id
where ut.app_id = 2619 and ut.platform = 1 and ut.created_at between now() - interval 7 day and now() and utm.app_version_id = 21536
and ut.exception_type = 1 ;
*/


-- Crash Impacted OS versions

select uov.version as Top_OS, count(ut.id) as Count
from user_tasks_metadata as utm 
inner join unique_os_version as uov on uov.id = utm.os_version
inner join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.platform = 1 and ut.app_version = '1.1.8 [15]' and ut.exception_type = 1 and ut.created_at between now() - interval 7 day and now()
group by uov.version
order by count desc;

/*
                     select up.id id, 
                            sum( asp.crash_count
                               ) value,
                            up.version name
                       from ue_summary.summary_v2_os_version_2619 asp
                       join unique_os_version up on asp.property_master_id = up.id
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by up.id, up.version
                     having value > 0
                      order by value desc
                     limit 10 ;
*/


-- Screen Crash


/*
select (case when uas.screen_label is null then uas.activity_screen else uas.screen_label end) as Screen,
count(ut.id) as count
from user_tasks as ut
inner join user_tasks_metadata as utm on utm.user_task_id = ut.id
inner join ue_events_base as ueb on ueb.usr_task_id = ut.id
inner join unique_activity_screen as uas on uas.id = ueb.screen_id
where ut.app_id = 2619 and ueb.type_id = 28 and ut.platform = 1 and ut.created_at between now() - interval 7 day and now() and ut.app_version = '1.1.8 [15]'
group by ueb.screen_id
order by count desc;
*/

select ifnull(uas.screen_label, uas.activity_screen) screen_name,
sum(sas.crash_count) num_of_visits
from ue_summary.summary_v2_activity_screen_2619 as sas
join unique_activity_screen as uas on sas.property_master_id = uas.id
where sas.app_id = 2619 
and sas.platform = 1
and sas.time_scope between now() - interval 7 day and now()
and sas.app_version_id = 21536
and uas.activity_screen != 'UNKNOWN' and uas.activity_screen != ''
group by screen_name having num_of_visits > 0
order by num_of_visits desc
limit 10;



-- Crash Impacted devices

select udm.model as Top_devices, count(ut.id) as Count
from user_tasks_metadata as utm 
inner join unique_device_model as udm on udm.id = utm.model
inner join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.created_at between now() - interval 7 day and now() and ut.exception_type = 1  and ut.platform = 1 and ut.app_version = '1.1.8 [15]'
group by udm.model
order by count desc
limit 10;


/*
                     select up.id id, 
                           sum(asp.crash_count
                   
                              ) value,
                           up.model name
                     from ue_summary.summary_v2_device_model_2619 asp
                     join unique_device_model up on asp.property_master_id = up.id
                     where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                     group by up.id, up.model
                     having value > 0
                     order by value desc
                    limit 10;
*/


-- Crash Impacted networks

select unt.name , count(ut.id)  as count
from user_tasks as ut
join unique_network_type as unt on unt.key = ut.network_type
where ut.app_id = 2619 and ut.created_at between now() - interval 7 day and now() and ut.platform = 1 and ut.exception_type = 1 and ut.app_version = '1.1.8 [15]'
group by unt.name
order by count desc
limit 10;

   /*                  select up.key id, 
                            sum(asp.crash_count
 
                               ) value,
                            up.name name
                       from ue_summary.summary_v2_network_type_2619 asp
                       join unique_network_type up on asp.property_master_id = up.key
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by up.key, up.name
                     having value > 0
                      order by value desc
                     limit 10 ;
                     */


# Page - ANR

-- ANR Stats

select sum(if(ut.exception_type = 2, 1, 0)) Total_ANR, 
count(distinct(case when um.custom_user_id is null then ifnull(um.device_id, '')else concat('c-',um.custom_user_id) end)) impacted_ANR_users
from user_tasks ut
join user_tasks_metadata um on ut.id = um.user_task_id
where ut.app_id = 2619 and ut.app_version = '1.1.8 [15]' and ut.platform = 1 and ut.exception_type = 2 and ut.created_at between now() - interval 7 day and now();

/*
select count(ut.id) as Total_Crash,
count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '') 
					else utm.custom_user_id end)) as impacted_crash
from user_tasks as ut 
join user_tasks_metadata as utm on utm.user_task_id = ut.id
where ut.app_id = 2619 and ut.platform = 1 and ut.created_at between now() - interval 7 day and now() and utm.app_version_id = 21536
and ut.exception_type = 2 ;
*/


-- ANR Impacted OS versions

select uov.version as Top_OS, count(ut.id) as Count
from user_tasks_metadata as utm 
inner join unique_os_version as uov on uov.id = utm.os_version
inner join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.platform = 1 and ut.app_version = '1.1.8 [15]' and ut.exception_type = 2 and ut.created_at between now() - interval 7 day and now()
group by uov.version
order by count desc;

/*
                     select up.id id, 
                            sum( asp.crash_count
                               ) value,
                            up.version name
                       from ue_summary.summary_v2_os_version_2619 asp
                       join unique_os_version up on asp.property_master_id = up.id
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by up.id, up.version
                     having value > 0
                      order by value desc
                     limit 10 ;
*/


-- Screen ANR


/*
select (case when uas.screen_label is null then uas.activity_screen else uas.screen_label end) as Screen,
count(ut.id) as count
from user_tasks as ut
inner join user_tasks_metadata as utm on utm.user_task_id = ut.id
inner join ue_events_base as ueb on ueb.usr_task_id = ut.id
inner join unique_activity_screen as uas on uas.id = ueb.screen_id
where ut.app_id = 2619 and ueb.type_id = 28 and ut.platform = 1 and ut.created_at between now() - interval 7 day and now() and ut.app_version = '1.1.8 [15]'
group by ueb.screen_id
order by count desc;
*/

select ifnull(uas.screen_label, uas.activity_screen) screen_name,
sum(sas.anr_count) num_of_visits
from ue_summary.summary_v2_activity_screen_2619 as sas
join unique_activity_screen as uas on sas.property_master_id = uas.id
where sas.app_id = 2619 
and sas.platform = 1
and sas.time_scope between now() - interval 7 day and now()
and sas.app_version_id = 21536
and uas.activity_screen != 'UNKNOWN' and uas.activity_screen != ''
group by screen_name having num_of_visits > 0
order by num_of_visits desc
limit 10;



-- ANR Impacted devices

select udm.model as Top_devices, count(ut.id) as Count
from user_tasks_metadata as utm 
inner join unique_device_model as udm on udm.id = utm.model
inner join user_tasks as ut on ut.id = utm.user_task_id
where ut.app_id = 2619 and ut.created_at between now() - interval 7 day and now() and ut.exception_type = 2  and ut.platform = 1 and ut.app_version = '1.1.8 [15]'
group by udm.model
order by count desc
limit 6;


/*
                     select up.id id, 
                           sum(asp.crash_count
                   
                              ) value,
                           up.model name
                     from ue_summary.summary_v2_device_model_2619 asp
                     join unique_device_model up on asp.property_master_id = up.id
                     where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                     group by up.id, up.model
                     having value > 0
                     order by value desc
                    limit 10;
*/



-- ANR Impacted networks

select unt.name , count(ut.id)  as count
from user_tasks as ut
join unique_network_type as unt on unt.key = ut.network_type
where ut.app_id = 2619 and ut.created_at between now() - interval 7 day and now() and ut.platform = 1 and ut.exception_type = 2 and ut.app_version = '1.1.8 [15]'
group by unt.name
order by count desc
limit 10;

   /*                  select up.key id, 
                            sum(asp.crash_count
 
                               ) value,
                            up.name name
                       from ue_summary.summary_v2_network_type_2619 asp
                       join unique_network_type up on asp.property_master_id = up.key
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by up.key, up.name
                     having value > 0
                      order by value desc
                     limit 10 ;
                     */




# Page - App Launch

-- App Launch Time

select up.version, round((sum(total_time)/sum(session_count))/1000,3) avg,
round((sum(case app_launch_type when 'HOT' then total_time else 0 end)/sum(case app_launch_type when 'HOT' then session_count else 0 end))/1000,3) hot_avg,
round((sum(case app_launch_type when 'COLD' then total_time else 0 end)/sum(case app_launch_type when 'COLD' then session_count else 0 end))/1000,3) cold_avg
from ue_summary.summary_v2_app_launch_2619 asp
JOIN unique_app_version up ON asp.app_version_id = up.id
where asp.app_id = 2619
and asp.platform = 1
and asp.time_scope between now() - interval 7 day and now()
and asp.app_version_id = 21536
and app_launch_type is not null
group by up.version
having hot_avg is not null or cold_avg is not null
order by avg desc;


-- App Launch Time - Top OS version

select up.version, round((sum(total_time)/sum(session_count))/1000,3) avg,
round((sum(case app_launch_type when 'HOT' then total_time else 0 end)/sum(case app_launch_type when 'HOT' then session_count else 0 end))/1000,3) hot_avg,
round((sum(case app_launch_type when 'COLD' then total_time else 0 end)/sum(case app_launch_type when 'COLD' then session_count else 0 end))/1000,3) cold_avg
from ue_summary.summary_v2_app_launch_2619 asp
JOIN unique_os_version up ON asp.os_version = up.id
where asp.app_id = 2619
and asp.platform = 1
and asp.time_scope between now() - interval 7 day and now()
and asp.app_version_id = 21536
and app_launch_type is not null
group by up.version
having hot_avg is not null or cold_avg is not null
order by avg desc
limit 5;


-- App Launch Time - Network

select up.name, round((sum(total_time)/sum(session_count))/1000,3) avg,
round((sum(case app_launch_type when 'HOT' then total_time else 0 end)/sum(case app_launch_type when 'HOT' then session_count else 0 end))/1000,3) hot_avg,
round((sum(case app_launch_type when 'COLD' then total_time else 0 end)/sum(case app_launch_type when 'COLD' then session_count else 0 end))/1000,3) cold_avg
from ue_summary.summary_v2_app_launch_2619 asp
JOIN unique_network_type up ON asp.network_type = up.id
where asp.app_id = 2619
and asp.platform = 1
and asp.time_scope between now() - interval 7 day and now()
and asp.app_version_id = 21536
and app_launch_type is not null
group by up.name
having hot_avg is not null or cold_avg is not null
order by avg desc
limit 5;

-- App Launch Time - Devices

select up.model, round((sum(total_time)/sum(session_count))/1000,3) avg,
round((sum(case app_launch_type when 'HOT' then total_time else 0 end)/sum(case app_launch_type when 'HOT' then session_count else 0 end))/1000,3) hot_avg,
round((sum(case app_launch_type when 'COLD' then total_time else 0 end)/sum(case app_launch_type when 'COLD' then session_count else 0 end))/1000,3) cold_avg
from ue_summary.summary_v2_app_launch_2619 asp
JOIN unique_device_model as up ON asp.device_id = up.id
where asp.app_id = 2619
and asp.platform = 1
and asp.time_scope between now() - interval 7 day and now()
and asp.app_version_id = 21536
and app_launch_type is not null
group by up.model
having hot_avg is not null or cold_avg is not null
order by avg desc
limit 5;


# Page - Screens

-- Most visited Screens
select ifnull(uas.screen_label, uas.activity_screen) screen_name,
sum(sas.full_count) num_of_visits
from ue_summary.summary_v2_activity_screen_2619 as sas
join unique_activity_screen as uas on sas.property_master_id = uas.id
where sas.app_id = 2619 
and sas.platform = 1 
and sas.time_scope between now() - interval 7 day and now()
and sas.app_version_id = 21536 
and uas.activity_screen != 'UNKNOWN' and uas.activity_screen != ''
group by screen_name having num_of_visits > 0
order by num_of_visits desc
limit 7;


-- Average Screen Time

select ifnull(up.screen_label, up.activity_screen) name,
floor(sum(asp.time_spent) / sum(asp.full_count)) value
from ue_summary.summary_v2_activity_screen_2619 asp
                     join unique_activity_screen up on asp.property_master_id = up.id
                     where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                        and up.activity_screen != ''
                        and up.activity_screen != 'UNKNOWN'
                     group by up.id, up.screen_label, up.activity_screen
                     having value > 0
                     order by value desc
                     limit 7;
   
# Page - Rage    
   
-- Rage Interactions

/* select (case when uas.screen_label is null then uas.activity_screen else uas.screen_label end) as Screen,
count(distinct(case when utm.custom_user_id is null then ifnull(utm.device_id, '')else concat('c-',utm.custom_user_id) end)) as user_count
from ue_events_base as ueb
inner join unique_activity_screen as uas on uas.id = ueb.screen_id
inner join user_tasks as ut on ut.id = ueb.usr_task_id
inner join user_tasks_metadata as utm on utm.user_task_id = ut.id
where ut.app_id = 2619 and ut.platform = 1 and ut.app_version = '1.1.8 [15]' and ueb.type_id = 22 and  ut.created_at between now() - interval 7 day and now()
group by ueb.screen_id
order by user_count desc
limit 10;*/

select ifnull(up.screen_label, up.activity_screen) name,sum(asp.rage_count) value
from ue_summary.summary_v2_activity_screen_2619 asp
join unique_activity_screen up on asp.property_master_id = up.id
where asp.app_id = 2619
and asp.platform = 1
and asp.time_scope between now() - interval 7 day and now()
and asp.app_version_id = 21536
and up.activity_screen != ''
and up.activity_screen != 'UNKNOWN'
group by up.screen_label, up.activity_screen
having value > 0
order by value desc
limit 10;


# Page - API


-- API Response Time                     
                     select asp.api_name name,
                            sum(asp.no_of_calls) Hits,
                            sum(asp.sum_of_duration)/sum(asp.no_of_calls) avg_response_time,
                            sum(asp.between_0_and_3) between_0_and_3,
                            sum(asp.between_3_and_5) between_3_and_5,
                            sum(asp.above_5) above_5
                       from ue_summary.summary_api_performance_2619 asp
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.created_at between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                        group by asp.app_api_id, asp.api_name
                       having Hits > 0
                        order by Hits desc
                        limit 5;		
                        
                        
                        
-- App Events

select uae.name, count(ut.id) as count
from ue_events_base as ueb
inner join unique_app_event as uae on uae.id = ueb.app_event_id
inner join user_tasks as ut on ut.id = ueb.usr_task_id
where ut.app_id = 2619 and ut.platform = 1 and ut.app_version = '1.1.8 [15]' and ut.created_at between now() - interval 7 day and now()
group by ueb.app_event_id
order by count desc
limit 10;

                /*     select concat(asp.property_master_id) id,
                            sum(asp.full_count) value,
                            case asp.type when 1 then up.name else upo.object end name
                       from ue_summary.summary_event_2619 asp
                       left join unique_app_event up on asp.type = 1 and asp.property_master_id = up.id
                       left join unique_object_name upo on asp.type = 2 and asp.property_master_id = upo.id
                      where asp.app_id = 2619
                        and asp.platform = 1
                        and asp.time_scope between now() - interval 7 day and now()
                        and asp.app_version_id = 21536
                      group by asp.type, 
                               asp.property_master_id,
                               up.name, upo.object
                     having value > 0
                      order by value desc
                      limit 10; */
                      
			




#Page 3

-- App Launch Stats

select up.version, round((sum(total_time)/sum(session_count))/1000,3) avg,
round((sum(case app_launch_type when 'HOT' then total_time else 0 end)/sum(case app_launch_type when 'HOT' then session_count else 0 end))/1000,3) hot_avg,
round((sum(case app_launch_type when 'COLD' then total_time else 0 end)/sum(case app_launch_type when 'COLD' then session_count else 0 end))/1000,3) cold_avg
from ue_summary.summary_v2_app_launch_2619 asp
JOIN unique_app_version up ON asp.app_version_id = up.id
where asp.app_id = 2619
and asp.platform = 1
and asp.time_scope between now() - interval 7 day and now()
and asp.app_version_id = 21536
and app_launch_type is not null
group by up.version
having hot_avg is not null or cold_avg is not null
order by avg desc;



          

                     

                     

# Page 5

-- App launch time daywise
select up.version, round((sum(total_time)/sum(session_count))/1000,3) avg,
round((sum(case app_launch_type when 'HOT' then total_time else 0 end)/sum(case app_launch_type when 'HOT' then session_count else 0 end))/1000,3) hot_avg,
round((sum(case app_launch_type when 'COLD' then total_time else 0 end)/sum(case app_launch_type when 'COLD' then session_count else 0 end))/1000,3) cold_avg
from ue_summary.summary_v2_app_launch_2619 asp
JOIN unique_app_version up ON asp.app_version_id = up.id
where asp.app_id = 2619
and asp.platform = 2
and asp.time_scope between '2022-09-23 18:30:00' and '2022-09-24 18:30:00'
and asp.app_version_id = 21525
and app_launch_type is not null
group by up.version
having hot_avg is not null or cold_avg is not null;