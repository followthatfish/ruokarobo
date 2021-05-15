*** Settings ***
Resource    keywords.resource
Resource    preferred_products.robot

*** Keywords ***
#Recipes are basically lists of products and their amounts which are added to the shopping list.

Varhaiskaalisalaatti ja ryynimakkarat
    [Documentation]    https://www.k-ruoka.fi/reseptit/varhaiskaalisalaatti-ja-ryynimakkarat
    Add Products To A Shopping List    Varhaiskaali ulkomainen
    Add Products To A Shopping List    Pirkka omena Granny Smith 1 lk    3
    Add Products To A Shopping List    ${turkkilainen_jogurtti_400g}
    Add Products To A Shopping List    ${hunaja_500g}
    Add Products To A Shopping List    HK Maakarit Chefs Special Ripen Ryynäri 260g