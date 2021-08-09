# ruokarobo
A Robot Framework project for automating your orders from Finnish online grocery store K-ruoka.fi.

## Examples
```
Tilaa ainekset Muttisoosiin
    Add Products To A Shopping List    ${mutti}
    Add Products To A Shopping List    ${sipuli}
    Add Products To A Shopping List    ${valkosipuli}
    Add Products To A Shopping List    ${oliiviöljy}
    Add Products To A Shopping List    Pirkka sokeri 1 kg
    #Add Products To A Shopping List    punaviini   (can't do that, sorry)
    Add Products To A Shopping List    Appelsiini Bruno
    Order Shopping List
    Report Price
```

Or, if you already have Muttisoosi in your recipes, simply
```
Tilaa ainekset Muttisoosiin
    Include Recipe    Muttisoosi    1
    Order Shopping List
    Report Price
```

## Description
Online shopping for groceries is constantly increasing. Even though the service might be very convenient, the process of ordering the things you need and want still may take a not insignificant amount of time.

ruokarobo offers a few different ways to automate said grocery orders for customers of Finnish retail operator K-ryhmä, and specifically via their online store at K-ruoka.fi. The author of this project is not affiliated with K-ryhmä or K-ruoka.fi.

ruokarobo is built on top of Robot Framework 3 and the [Browser Library](https://robotframework-browser.org/).

## What it does
* Provides a Robot Framework project with keywords, resources and examples for logging in to K-ruoka.fi and adding products to a shopping cart there.
* Allows you to keep a list of your preferred products as variables and use said variables to order the products you like to use.
* Allows you to define your recipes, which consist of products. These can later be ordered with a single keyword.
* Allows you to order varying amounts of products and multiplications of recipes. If you want to make a double dose of lasagne, it's easy to automate the order part.

## What it doesn't do
* Log in to K-ruoka.fi. You have to perform the login in the browser the automation starts up. After you have logged in the automation detects that and resumes automatically.
* Support choosing the store to order from. You'll do that quicker by logging in to K-ruoka.fi and selecting the store you'd like to get your order from. Just change the store to one you'd like to order from and leave it be. When ruokarobo logs in, it'll use the same store for ordering.
* Allow you to complete the order automatically. You will need to complete the purchase, select a suitable delivery time and complete the payment by yourself.

## Getting Started

### Prerequisites

* [Robot Framework](https://github.com/robotframework/robotframework)
  * Project has only been tested with Robot Framework 3.2.2 and Python 3.9.4.
* [Browser Library for Robot Framework](https://github.com/MarketSquare/robotframework-browser#robotframework-browser)  
  * Browser Library has a bunch of prerequisites in itself, such as Node.js. 
* A way to edit the files and run the tests, such as an IDE
  * Project has been created with the [standalone release of RED](https://github.com/nokia/RED/releases/tag/0.9.5)

### Installing
1. Make sure you've installed the prerequisites.
2. Clone this repository or [download a release](https://github.com/followthatfish/ruokarobo/releases/).
3. Import the project to your IDE or Robot Framework environment of choice. Make sure the IDE knows where the Browser library and the files in this project are located.

### Usage
Open `test_files/make orders.robot` to see an example order. It contains a few different ways of adding products to the cart.
* You can also use this test suite to write your own orders in. Do that by writing a new "test case" for the order.

#### Adding products directly to the cart
To directly add a product straight into a cart in K-ruoka.fi:
`Add Products    Järvikylä ruohosipuli ruukku Suomi 1lk`
Or you can add several by using the optional number_of_products argument:
`Add Products    Järvikylä ruohosipuli ruukku Suomi 1lk    4`
* If no number is provided, the product is added once.
* The number also works for products which are sold by weight instead of number. K-ruoka.fi operates in 100g increments, so you can add 5 of such products to order 500 grams of it.

#### Adding products to a local shopping list
You can also use the shopping list feature which writes a file of the products and later requires another keyword to complete the order from the file.
* The implementation is half-baked in this initial release, but the main point behind using the list is eventually to increase the number of a specific product if it already exists in the list, if something needs to order more of the same thing. Now all additions are appended to the file, which means that in this case you end up searching for the product more than once.

Add products to a shopping list like this:
`Add Products To A Shopping List    Järvikylä ruohosipuli ruukku Suomi 1lk`

#### Ordering the shopping list
When you're done in compiling the list, make sure to include the `Order Shopping List` keyword in your test.

#### Assigning products to variables
You can reference the products via variables
`Add Products To A Shopping List    ${sipuli}    4`

Edit the file `resource_files/preferred.products.robot` to assign your favourite products to variables, which you can then reference in tests and recipes. The file contains a list of products as examples, but it is probably best if you replace them with your own, as everything included may not be available at your store.

#### Using recipes
Recipes consist of products and their amounts. You can order the products needed for a recipe by using the `Include Recipe` keyword. 
The keyword expects two arguments: `[name_of_recipe, multiplication]`. You can use the multiplication argument for ordering X times the amount of products in the recipe. If your recipe originally includes a product 3 times, it is then added 3*X times.

`Include Recipe    Varhaiskaalisalaatti ja ryynimakkarat    1`

#### Adding recipes
Open `recipes.robot` to see an example order. It contains a few different ways of adding products to the cart.
You can use the example provided as a template for creating your own. Recipes function basically as collections of products, which can be ordered quickly.

#### Final steps
If you have used the shopping list, make sure to include the `Order Shopping List` keyword in your test. This is best positioned as second to last keyword in a test.
If you'd like Robot Framework to tell you the price of the products that were added to the cart, use the keyword `Report Price` as the last in your test.

#### Performing the automation
To perform the automation, run the test you've written in your IDE Robot Framework environment. When the browser enters the login screen, login by desired method. When ruokarobo notices that you have logged in, it resumes the automation.

### Completing the order
After you have let the robot do its thing you should have all the products you need in your K-ruoka.fi shopping cart.

To complete the order, you then need to log in to K-ruoka.fi in your regular browser with the same credentials. When you do this, the shopping cart contains all the products the robot added there, and you're left with selecting the delivery time and providing payment details.

### Common issues
* Certain characters in product names can cause the tests to crash. Avoid using at least the period (.) or the exclamation mark (!) when referencing to products.
  * This is a result of the product names being passed to XPATH selectors which search and add the products to the cart. Single quotes (') should be fine, but other characters with special purposes in XPATHs may be problematic.
  * As a workaround you can provide a partial name for the product. The keywords which add products to the cart do not require complete product names, but instead select the first matching search result.

### Roadmap
Current state of ruokarobo is fully functional. There are however aspects which may be improved in future releases - see [issues](https://github.com/followthatfish/ruokarobo/issues) for more information.
* Smarter use of Browser Library capabilities
  * The keywords contain a bunch of Sleeps, which is not ideal. Browser provides the cool `Wait For Element State` keyword, which may be utilized later to eliminate the Sleeps.
* Refactor recipes
  * Recipes currently contain calls to the keywords which add the products either directly to the cart or the shopping list. They could be refactored to only be simpler lists of ingredients.

## Author
Samuli Vuorinen
* [followthatfish on GitHub](https://github.com/followthatfish)
* [@SamuliVuorinen on Twitter](https://twitter.com/samulivuorinen)

## Version History

* 1.3
  * Made the shopping list smarter. You no longer have duplicate instances of a product in the shopping list if, say, two different recipes need to order Mutti. This is a performance upgrade.
  * Also other performance upgrades.
* 1.2
  * Removed the previous login implementation. **Using ruokarobo no longer requires you to store your login credentials in a file. From this version on you are expected to complete the login in the browser the automation launches.** After you have done that, the automation resumes.
* 1.1
  * Compatibility fixes  
* 1.0.2
  * Further clarification about how credentials are stored in readme
* 1.0.1
  * Added examples to the readme
* 1.0
  * Initial public release

## License

This project is licensed under the GNU General Public License v3.0 License - see the LICENSE file for details

## Acknowledgments

* [DomPizzie for the readme template](https://gist.github.com/DomPizzie/7a5ff55ffa9081f2de27c315f5018afc#file-readme-template-md)
* [K-ruoka.fi](https://www.k-ruoka.fi) for being quite easy to automate, even though an API would be nice too.
