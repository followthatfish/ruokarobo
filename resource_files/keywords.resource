*** Settings ***
Library    Browser
Library    Collections
Library    OperatingSystem
Resource    recipes.robot

*** Variables ***
&{shopping-list}

*** Keywords ***
Initialize Shopping List File
    [Documentation]    Create a blank shopping list text file. This is used by the keyword Add Products To A Shopping List.
    ...    Products added here can later be added to the shopping cart by calling keyword Order Shopping List.
    Create File    shopping_list.txt    content=    encoding=UTF-8

Add Products
    [Arguments]    ${searched_product}    ${number_of_products}=1
    [Documentation]    Searches for the product, which is passed to the keyword as an argument. Adds desired number of product to the cart.
    Type Text    //div[@class='product-search-input-container']//input    ${searched_product}
    Click    //div[contains(@class,'product-result-item')]//a[contains(@title,"${searched_product}")]
    Repeat Keyword    ${number_of_products}    Click    //div[@class='amount-controls active']//button[@title='Lisää']
    Click    //button[@class='modal__close']

Add Products To A Shopping List
    [Arguments]    ${searched_product}    ${number_of_products}=1
    [Documentation]    Adds the desired number of products to the shopping list dictionary.
    ...    The shopping list can be later processed and added to the cart in K-ruoka.fi by using the keyword Order Shopping List.
    #Check if the product is found in the shopping list dictionary already.
    ${is_product_in_list}    Run Keyword And Return Status    Get From Dictionary    ${shopping-list}    ${searched_product}
    #If product is not in the shopping list, set it and its amount there. If it is, increase the amount instead.
    Run Keyword If    ${is_product_in_list} is False    Set To Dictionary    ${shopping-list}    ${searched_product}    ${number_of_products}
    ...    ELSE    Increase Amount Of Product    ${searched_product}    ${number_of_products}
    Log    Shopping list contains: ${shopping-list}

Increase Amount Of Product
    [Arguments]    ${searched_product}    ${number_of_products}=1
    [Documentation]    This keyword is called by Add Products To A Shopping List in cases where the product is already found in the shopping list.
    #Get the amount of product from the list.
    ${previous_amount}    Get From Dictionary    ${shopping-list}    ${searched_product}
    #Create a new variable by adding together the old amount and the amount being added at this poinmt.
    ${new_amount}    Evaluate    ${previous_amount}+${number_of_products}
    #Update the shopping list by replacing the previous amount of product with the new amount.
    Set To Dictionary    ${shopping-list}    ${searched_product}    ${new_amount}
    Log    Increased amount of ${searched_product} in shopping list.

Log Shopping List Into A File
    ${ostoslista}    Convert To String    ${shopping-list}
    Append To File    shopping_list.txt    ${ostoslista}    encoding=UTF-8

Order Shopping List
    [Documentation]    Adds products from the shopping cart dictionary to the cart.
    Log Shopping List Into A File
    #Loop through the shopping list and call Add Products with the products (keys) and their values to create the shopping cart in K-ruoka.fi.
    FOR    ${product}    IN    &{shopping-list}
        Log    ${product}
        Add Products    ${product}[0]    ${product}[1]
    END

Include Recipe
    [Arguments]    ${name_of_recipe}    ${multiplication}
    [Documentation]    Adds ingredients of the desired recipe to the cart. Multiplication argument can be used to add products several times.
    Sleep    1s
    Repeat Keyword    ${multiplication}    Run Keyword    ${name_of_recipe}

Report Price
    [Documentation]    Displays the current price of cart in text. Use this to log the price in the RF result files.
    ${current_price}    Get Text    //div[@class='total-price']
    Log    Ostoskorin hinta: ${current_price} euroa.
