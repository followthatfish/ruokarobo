*** Settings ***
Library    Browser
Resource    ../resource_files/keywords.resource
Resource    ../resource_files/recipes.robot

Suite Setup    Initialize Shopping List File

*** Test Cases ***
Example Order
    Add Products To A Shopping List    ${sipuli}    4
    Add Products To A Shopping List    ${hammastahna}
    Add Products To A Shopping List    Järvikylä ruohosipuli ruukku Suomi 1lk
    Include Recipe    Varhaiskaalisalaatti ja ryynimakkarat    3
    Add Products To A Shopping List    ${sipuli}
    Add Products To A Shopping List    ${sipuli}    5
    Order Shopping List
    Report Price