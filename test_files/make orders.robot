*** Settings ***
Library    Browser
Resource    ../resource_files/keywords.resource

Suite Setup    Initialize Shopping List File

*** Test Cases ***
Example Order
    Add Products To A Shopping List    ${sipuli}
    Add Products To A Shopping List    ${hammastahna}
    Include Recipe    Lasagne    1
    Order Shopping List
    Report Price