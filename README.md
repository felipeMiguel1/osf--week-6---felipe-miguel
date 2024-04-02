Felipe Miguel - week 6 projects


project 1 trigger:
for this project i creat a custom field (IsPrimary) to indentify the primary contact of the account and the custom field primary contact phone
the validation for only allow 1 primery contact and the primary phone and replicate the primary phone number is on the trigger

![image](https://github.com/felipeMiguel1/osf--week-6---felipe-miguel/assets/116683605/2fe79fb5-9981-4d43-8c12-b54f36510b64)

project 2 batch job
for project 2 i did two apex classes, one do the schedule part and the other is all logic to select the amounts, create the email and send the email.  

to schedule the job you go to the developer console and schedule them like the follow exemples

// Daily at 10:00 AM
System.schedule('DailyOpportunitySummaryBatchJob', '0 0 10 * * ?', new OpportunitySummaryScheduler());

// Weekly (Friday at 1:00 PM)
System.schedule('WeeklyOpportunitySummaryBatchJob', '0 0 13 ? * FRI', new OpportunitySummaryScheduler());

// Monthly (Last Friday of the Month at 6:00 PM)
System.schedule('MonthlyOpportunitySummaryBatchJob', '0 0 18 ? * 6L', new OpportunitySummaryScheduler());



i had a problem with this project, the class current is sending the email only to my personal email and the email is empty
![image](https://github.com/felipeMiguel1/osf--week-6---felipe-miguel/assets/116683605/eeba0c6b-ef56-4e61-9b00-7df1cbdbe838)
but there are no code errors and the job runs whithout problems


Project 3 lwc whit weather api

for this project i did something different, i create the lwc to display the current weather but i also add somemething else. To make the lwc more fun i add a field to write the city name so you can check the weather on any city just by typing its name


![image](https://github.com/felipeMiguel1/osf--week-6---felipe-miguel/assets/116683605/27c10f31-5653-4217-9bfe-5c728f7dd9f2)
![image](https://github.com/felipeMiguel1/osf--week-6---felipe-miguel/assets/116683605/12a2caa7-ae6b-4767-be3f-dced041208e7)


Project 4 VisualForce page

In this project i created the visual force page and add it to an account custom butto call SetPrimary
![image](https://github.com/felipeMiguel1/osf--week-6---felipe-miguel/assets/116683605/f8ba99eb-a7d2-4400-b67b-3b1ff389c298)

The visual force page uses the IsPrimary__c custom field crated in the other projects, in the page you can edit and save some account fields, search contacts by name and set a contact as primary (this button works by setting all contacts as not primary before updating the select contact as primary so ir works with the project 1 trigger).
![image](https://github.com/felipeMiguel1/osf--week-6---felipe-miguel/assets/116683605/60a898b5-207e-4939-84c2-c7e857566236)

