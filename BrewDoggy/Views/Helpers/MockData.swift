//
//  MockData.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-10.
//

import Foundation
import CoreData

struct MockData {
    var viewContext: NSManagedObjectContext
  
    init(context: NSManagedObjectContext) {
        viewContext = context
        addMockData()
    }
    
    private func addMockData() {
        //-----------------------------------------------//
        //                    BEER                       //
        //-----------------------------------------------//
        var newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Beer"
        newBrewType.picture = "beerStandard"
        saveViewContext()

        var newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = "beerStandard"
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2009, month: 11, day: 1).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        var newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2,5"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Hops"
        newRecipteItem.amount = "100"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "-"
        newRecipteItem.measurement = "see instructions"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Belgian Lager"
        newRecipe.picture = "belgianLager"
        newRecipe.instructions = "Boil 5 liters of water together with 500g Light Dry Malt in a large saucepan (~ 8 l). Add Hallertau Hersbrucker hops and cook for 5 minutes. Remove the pan from the heat. Put the saucepan in a cold water bath for 15 minutes. Then strain the liquid into the fermenter. Add the beer batch and the malt extract to the fermenter. Stir. Fill with cold water to the mark for 20 liters. Stir. Check the temperature and top up with hot or cold water to reach 23 liters and 18 ° C. Stir. Sprinkle the dry yeast (both bags) over the surface of the fermenter and put on the lid. Place the fermenter away from direct sunlight and leave to ferment at as close to 12-15 ° C as possible. The fermentation should take a total of about 12-20 days. Starting from day 7, measure the density daily. The fermentation is complete when the density is stable over 2 days. The FG value should be about 1008."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 4).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Aromatic"
        newRecipteItem.amount = "200"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Dark Candy"
        newRecipteItem.amount = "200"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Pale Malt"
        newRecipteItem.amount = "2"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Amarilo"
        newRecipteItem.amount = "8"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: East Kent"
        newRecipteItem.amount = "20"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Cascade"
        newRecipteItem.amount = "100"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Liquid yeast"
        newRecipteItem.amount = "1"
        newRecipteItem.measurement = "pack"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Easy IPA"
        newRecipe.picture = "easyipa"
        newRecipe.instructions = "Heat 6 liters of water in a large saucepan to 77 degrees. Crush whole malt if you bought it. Then brush into a bowl gradually. Weigh crushed malt and place in the fermenter. Mashing in: pour on 77 degrees water and stir. Beat in the entire fermenter, even the bottom, in a blanket or blanket and let stand for a total of 90 minutes. Boil water in a kettle or saucepan. Check the temperature which should be 67 degrees every quarter with a thermometer, of course the temperature drops gradually and then you add boiling water and stir and measure the temperature again so that you always have as close to 67 degrees as you can. Then the enzymes in the malt break down the sugar so that it can later ferment to alcohol. Mashing out: in order for the enzymes to stop working, you take out a third of the mash and boil it. Then add to the rest of the mash - then the temperature is raised to about 75-80 degrees. Stir and let stand for 15 minutes. Heat and saucepan with about 3 liters of water to 75-80 degrees on the stove. Prepare to strain the mash. Put a silk in a yeast barrel on a chair. Prepare another yeast barrel next to it with a siphon or hose in between. Take a small saucepan or scoop and catch as much malt as you can and pour in the sieve so that it forms like a filter bed. Continue pouring over the mash and strain it through the sieve. Suck in the siphon so that you get suction in the other fermenter next to it. When you have about 3.5 liters of strained mash (which is now called sweet wort), take it and pour it into a saucepan and heat it to 75-80 degrees. Pour it through the sieve again. In this way, you leach all the sugar out of the malt and the wort becomes shinier (and thus the beer less cloudy). Leach the last sugar from the malt in the silk with about 2-3 liters of extra water that keeps 75-80 degrees. Time to boil the wort with hops: Pour and boil the sweet wort in a large saucepan of about 15-20 liters.  Weigh hops. Calculate how the beers will be (its IBU), ie the amount of hops you will add, according to the formula and the hops' alpha acid (which varies and is stated on the package). The number of IBUs is 3 times below centigrams of alpha acid per liter of wort. The wort should boil for an hour in total. Hops that are put in at the beginning give the most bitterness. Here, hops have been added in three rounds. Add the first batch of Amarillo hops, stir and cook for 40 minutes. Add the second round of East Kent Golding and stir. Cook for another 17 minutes. Add the last batch of hops of Cascade and cook for another 3 minutes. Remove from the heat and strain into a fermenter through a colander. Put the lid on. Allow to cool to room temperature. The wort may stand overnight. Stir in the yeast and ferment with a water trap at room temperature for 10 days. Carefully drop into another fermenter. Boil 3 g of sugar per liter of fermented beer (30 grams to 10 liters) together with a few dl of water (this is so that the sugar dissolves evenly in the beer). Stir in the sugar mixture into the beer. The sugar is added so that it continues to ferment in the bottle and some carbon dioxide is formed. Pour the beer into bottles and put on a cap. Store the beer at room temperature for another 10 days. Cool your IPA before serving."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 5).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Aromatic"
        newRecipteItem.amount = "200"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Dark Candy"
        newRecipteItem.amount = "200"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Pale Malt"
        newRecipteItem.amount = "2"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Amarilo"
        newRecipteItem.amount = "8"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: East Kent"
        newRecipteItem.amount = "20"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Cascade"
        newRecipteItem.amount = "100"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Liquid yeast"
        newRecipteItem.amount = "1"
        newRecipteItem.measurement = "pack"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    WINE                       //
        //-----------------------------------------------//
        newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Wine"
        newBrewType.picture = "wineStandard"
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = "wineStandard"
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 1998, month: 11, day: 1).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Fruit"
        newRecipteItem.amount = "6"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "8"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,8"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Wine yeast"
        newRecipteItem.amount = "-"
        newRecipteItem.measurement = "see instructions"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Pear wine"
        newRecipe.picture = "pearWine"
        newRecipe.instructions = "Dice pears, with peel and core, mix with rowanberries in a wine damejeanne or ice bucket. Add lukewarm water (ideal temperature 25-30 degrees), vitamin B, yeast nutrient and yeast. Stir and let stand for 3 days. Strain off the fruit remains. Mix in the sugar and stir until dissolved. Adjust to 10 liters volume with lukewarm water and let the wine ferment for a few more days. The sugar content must have dropped significantly. Taste it too. Redraw it to a new vessel without the bottom set. After a few days, you can finish the fermentation with a little Campden powder to be sure that it does not continue to ferment after bottling."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 3).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Pears"
        newRecipteItem.amount = "6"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Rowan berries"
        newRecipteItem.amount = "0,5"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "8"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,8"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Campden powder"
        newRecipteItem.amount = "1"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "B-vitamin"
        newRecipteItem.amount = "6"
        newRecipteItem.measurement = "mg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast nutrient"
        newRecipteItem.amount = "3"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Wine yeast"
        newRecipteItem.amount = "-"
        newRecipteItem.measurement = "see instructions"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Apple wine"
        newRecipe.picture = "AppleWineRecipe2x"
        newRecipe.instructions = "Dice apples, with peel and core, mix with rowanberries in a wine damejeanne or ice bucket. Add lukewarm water (ideal temperature 25-30 degrees), vitamin B, yeast nutrient and yeast. Stir and let stand for 3 days. Strain off the fruit remains. Mix in the sugar and stir until dissolved. Adjust to 10 liters volume with lukewarm water and let the wine ferment for a few more days. The sugar content must have dropped significantly. Taste it too. Redraw it to a new vessel without the bottom set. After a few days, you can finish the fermentation with a little Campden powder to be sure that it does not continue to ferment after bottling."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 6).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Apples"
        newRecipteItem.amount = "6"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Rowan berries"
        newRecipteItem.amount = "0,5"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "8"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,8"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Campden powder"
        newRecipteItem.amount = "1"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "B-vitamin"
        newRecipteItem.amount = "6"
        newRecipteItem.measurement = "mg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast nutrient"
        newRecipteItem.amount = "3"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Wine yeast"
        newRecipteItem.amount = "-"
        newRecipteItem.measurement = "see instructions"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    MEAD                       //
        //-----------------------------------------------//
        newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Mead"
        newBrewType.picture = "meadStandard"
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = "meadStandard"
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 1997, month: 9, day: 2).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Honey"
        newRecipteItem.amount = "1"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "-"
        newRecipteItem.measurement = "see instructions"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Viking Mead"
        newRecipe.picture = "meadRecipe"
        newRecipe.instructions = "Heat about 2 liters of water, dissolve the honey and malt. Cook. Let boil for 45 minutes. Pour 10 liters of cold water into the ice bucket. Pour on the brew, fill with water to the 20 liter mark. Add the yeast and stir. Leave with a towel over. When foam has formed on the surface, takes about a day, the fermentation has begun. Add 5 dl sugar and stir. After another two days, add 1 kg of sugar and 2 liters of water. When the fermentation starts to slow down, add the rest of the sugar and water. After another three weeks when the mead is completely fermented. Fill it in a Carboy.."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 1).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2,5"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Honey"
        newRecipteItem.amount = "4"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,5"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "1"
        newRecipteItem.measurement = "pkt"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    OTHER                      //
        //-----------------------------------------------//
        newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Other"
        newBrewType.picture = "otherStandard"
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = "otherStandard"
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "6"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Juniper"
        newRecipteItem.amount = "1"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "-"
        newRecipteItem.measurement = "see instructions"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Dricku"
        newRecipe.picture = "dricku2"
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 2).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2,5"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.measurement = "liters"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Hops"
        newRecipteItem.amount = "50"
        newRecipteItem.measurement = "g"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "6"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Brown Sugar"
        newRecipteItem.amount = "2"
        newRecipteItem.measurement = "kg"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Juniper"
        newRecipteItem.amount = "2-2"
        newRecipteItem.measurement = "branches"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "1/4"
        newRecipteItem.measurement = "pkt"
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()
    }
    
    private func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
