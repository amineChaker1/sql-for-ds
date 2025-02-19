USDA Production Data Analysis: <br/>
The USDA has been tracking the production of various agricultural commodities across different states and storing it into different csv files, The datasets include milk_production, cheese_production, egg_production, coffee_production, honey_production, yogurt_production, and a state_lookup table. The data spans multiple years and states, with varying levels of production for each commodity.
To generate insights from this data to aid in future planning and decision-making. I used SQL queries  in SQL Server to achieve the following objectives : 
- Assess state-by-state production for each commodity.
- Identify trends or anomalies.
- Offer data-backed suggestions for areas that may need more attention.
In order to surface the insight needed to reach these objectives we need to answer some questions about the data the most important of them I did is :
Which states had cheese production greater than 100 million in April 2023? The Cheese Department wants to focus their marketing efforts there. How many states are there? <br/>
![pr1](https://github.com/user-attachments/assets/cf0f418f-f943-4163-81a5-d1b318bf8ec5) <br/>

State                                              State_ANSI
-------------------------------------------------- ----------
CALIFORNIA                                         6
WISCONSIN                                          55      
What’s the total yogurt production for states in the year 2022 which also have cheese production data from 2023? This will help the Dairy Division in their planning.<br/>
 ![pr2](https://github.com/user-attachments/assets/57cc1f6b-39d7-4839-9137-83e392dff9ec) <br/>
 
TOTAL_YOGHURT_PRODUCTION
------------------------
1171095000
<br/> Which states from state_lookup that are missing from milk_production in 2023 ? How many states are there?
![pr4](https://github.com/user-attachments/assets/7e23b13c-03ec-4b31-9d5c-e0646e768c56)<br/>
 
COUNT_OF_MISSING_MILK_PRODUCTION_STATE_IN_2023
----------------------------------------------
26
