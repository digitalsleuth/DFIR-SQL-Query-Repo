SELECT message.rowid,
chat_message_join.chat_id,
message.handle_id,
message.text,
message.service,
message.account,
chat.account_login,
chat.chat_identifier,
case when LENGTH(chat_message_join.message_date)=18 then 
datetime(chat_message_join.message_date/1000000000 + 978307200,'unixepoch','localtime')
when LENGTH(chat_message_join.message_date)=9 then 
datetime(chat_message_join.message_date + 978307200,'unixepoch','localtime')
else 'NA'
END as "Message Date",
case when LENGTH(message.date_read)=18 then
datetime(message.date_read/1000000000 + 978307200,'unixepoch','localtime')
when LENGTH(message.date_read)=9 then
datetime(message.date_read+978307200,'unixepoch','localtime')
else 'NA'
END as "Date Read",
case when message.is_read=1
then 'Incoming'
when message.is_read=0
then 'Outgoing'
end as "Message Direction",
case when LENGTH(chat.last_read_message_timestamp)=18 then 
datetime(chat.last_read_message_timestamp/1000000000+978307200,'unixepoch','localtime')
when LENGTH(chat.last_read_message_timestamp)=9 then
datetime(chat.last_read_message_timestamp + 978307200,'unixepoch','localtime')
else 'NA'
END as "Last Read",
attachment.filename,
datetime(attachment.created_date+978307200,'unixepoch','localtime') AS "Attachment Date",
attachment.mime_type,
attachment.total_bytes
FROM message
left join chat_message_join on chat_message_join.message_id=message.ROWID
left join chat on chat.ROWID=chat_message_join.chat_id
left join attachment on attachment.ROWID=chat_message_join.chat_id
order by message.date_read desc;
