*** Settings ***
Library    Browser
Documentation    Creates the browser instance, goes to k-ruoka.fi and expects the user to log into the service before proceeding with the automation.
Suite Setup    Initialize Browser And Login
Suite Teardown    Kill Browser

*** Variables ***
${give_consent}    //div[@class='kc-buttons-container']/button/span[contains(text(),'Hyväksy kaikki')]

*** Keywords ***
Initialize Browser And Login
    New Browser    firefox    headless=false    slowMo=50ms
    New Context    viewport={'width': 1680, 'height': 1080}
    New Page    https://www.k-ruoka.fi
    Click    ${give_consent}
    Click    //span[contains(text(),'Kirjaudu')]
    Click    //span[contains(text(),'Kirjaudu sisään')]
    #Waits for the user to log in before proceeding and starting to add products. Increase the timeout value below (in seconds) if logging in takes longer.
    Wait For Elements State    //span[@id='username']    visible    timeout=30s
    Go To    https://www.k-ruoka.fi/kauppa

Kill Browser
    Close Browser