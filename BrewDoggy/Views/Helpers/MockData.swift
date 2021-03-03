//
//  MockData.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-02-10.
//

import Foundation
import CoreData
import SwiftUI

// Add lots of mockdata to database
struct MockData {
    var viewContext: NSManagedObjectContext
  
    init(context: NSManagedObjectContext) {
        viewContext = context
        addMockData()
    }
    
    private func addMockData() {
        //-----------------------------------------------//
        //                 UNIT TYPE                     //
        //-----------------------------------------------//
        let all = UnitType(context: viewContext)
        all.id = UUID()
        all.unitTypeSort = 0
        all.unitTypeName = "All"
        all.unitTypePic = ""
        all.timestamp = Date()
        saveViewContext()

        let met = UnitType(context: viewContext)
        met.id = UUID()
        met.unitTypeSort = 1
        met.unitTypeName = "Metric"
        met.unitTypePic = "unFlag"
        met.timestamp = Date()
        saveViewContext()

        let imp = UnitType(context: viewContext)
        imp.id = UUID()
        imp.unitTypeSort = 2
        imp.unitTypeName = "Imperial"
        imp.unitTypePic = "ukFlag"
        imp.timestamp = Date()
        saveViewContext()

        let us = UnitType(context: viewContext)
        us.id = UUID()
        us.unitTypeSort = 3
        us.unitTypeName = "US"
        us.unitTypePic = "usFlag"
        us.timestamp = Date()
        saveViewContext()

        //-----------------------------------------------//
        //                    UNITS                      //
        //-----------------------------------------------//
        let litre = Unit(context:  viewContext)
        litre.id = UUID()
        litre.unitToUnitType = met
        litre.unitDescription = "litre"
        litre.unitAbbreviation = "l"
        litre.toImp = 0.22              //Covert to Gallon
        litre.toUS = 0.2642
        litre.toImpStr = "gal"
        litre.toUSStr = "gal"
        litre.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 1).date!
        saveViewContext()

        let decilitre = Unit(context:  viewContext)
        decilitre.id = UUID()
        decilitre.unitToUnitType = met
        decilitre.unitDescription = "decilitre"
        decilitre.unitAbbreviation = "dl"
        decilitre.toImp = 0.176         //Covert to Pint
        decilitre.toUS = 0.2113
        decilitre.toImpStr = "pt"
        decilitre.toUSStr = "pt"
        decilitre.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 2).date!
        saveViewContext()

        let mililitre = Unit(context:  viewContext)
        mililitre.id = UUID()
        mililitre.unitToUnitType = met
        mililitre.unitDescription = "mililitre"
        mililitre.unitAbbreviation = "ml"
        mililitre.toImp = 0.0352        //Convert to fl.Oz
        mililitre.toUS = 0.0338
        mililitre.toImpStr = "fl.Oz"
        mililitre.toUSStr = "fl.Oz"
        mililitre.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 3).date!
        saveViewContext()

        let gallon = Unit(context:  viewContext)
        gallon.id = UUID()
        gallon.unitToUnitType = imp
        gallon.unitDescription = "gallon"
        gallon.unitAbbreviation = "gal"
        gallon.toMet = 4.546        //Convert to litre
        gallon.toUS = 1.201
        gallon.toMetStr = "l"
        gallon.toUSStr = "gal"
        gallon.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 4).date!
        saveViewContext()

        let pint = Unit(context:  viewContext)
        pint.id = UUID()
        pint.unitToUnitType = imp
        pint.unitDescription = "pint"
        pint.unitAbbreviation = "pt"
        pint.toMet = 5.6826        //Convert to dl
        pint.toUS = 1.201
        pint.toMetStr = "dl"
        pint.toUSStr = "pt"
        pint.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 5).date!
        saveViewContext()

        let flOz = Unit(context:  viewContext)
        flOz.id = UUID()
        flOz.unitToUnitType = imp
        flOz.unitDescription = "fluid ounce"
        flOz.unitAbbreviation = "fl.oz"
        flOz.toMet = 28.41          //Convert to ml
        flOz.toUS = 1.041
        flOz.toMetStr = "ml"
        flOz.toUSStr = "fl.oz"
        flOz.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 6).date!
        saveViewContext()

        let gallonUS = Unit(context:  viewContext)
        gallonUS.id = UUID()
        gallonUS.unitToUnitType = us
        gallonUS.unitDescription = "gallon"
        gallonUS.unitAbbreviation = "gal"
        gallonUS.toMet = 3.785        //Convert to litre
        gallonUS.toUS = 0.8326
        gallonUS.toMetStr = "l"
        gallonUS.toImpStr = "gal"
        gallonUS.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 7).date!
        saveViewContext()

        let pintUS = Unit(context:  viewContext)
        pintUS.id = UUID()
        pintUS.unitToUnitType = us
        pintUS.unitDescription = "pint"
        pintUS.unitAbbreviation = "pt"
        pintUS.toMet = 4.7318        //Convert to dl
        pintUS.toUS = 0.8327
        pintUS.toMetStr = "dl"
        pintUS.toImpStr = "pt"
        pintUS.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 8).date!
        saveViewContext()

        let flOzUS = Unit(context:  viewContext)
        flOzUS.id = UUID()
        flOzUS.unitToUnitType = us
        flOzUS.unitDescription = "fluid ounce"
        flOzUS.unitAbbreviation = "fl.oz"
        flOzUS.toMet = 29.57          //Convert to ml
        flOzUS.toUS = 0.9608
        flOzUS.toMetStr = "ml"
        flOzUS.toImpStr = "fl.oz"
        flOzUS.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 9).date!
        saveViewContext()

        let tableSpoon = Unit(context:  viewContext)
        tableSpoon.id = UUID()
        tableSpoon.unitToUnitType = all
        tableSpoon.unitDescription = "Tablespoon"
        tableSpoon.unitAbbreviation = "Tbsp"
        tableSpoon.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 10).date!
        saveViewContext()

        let teaSpoon = Unit(context:  viewContext)
        teaSpoon.id = UUID()
        teaSpoon.unitToUnitType = all
        teaSpoon.unitDescription = "Teaspoon"
        teaSpoon.unitAbbreviation = "tsp"
        teaSpoon.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 11).date!
        saveViewContext()

        let cup = Unit(context:  viewContext)
        cup.id = UUID()
        cup.unitToUnitType = all
        cup.unitDescription = "Cup"
        cup.unitAbbreviation = "cup"
        cup.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 12).date!
        saveViewContext()

        let packet = Unit(context:  viewContext)
        packet.id = UUID()
        packet.unitToUnitType = all
        packet.unitDescription = "Packet"
        packet.unitAbbreviation = "pkt"
        packet.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 21).date!
        saveViewContext()

        let tablet = Unit(context:  viewContext)
        tablet.id = UUID()
        tablet.unitToUnitType = all
        tablet.unitDescription = "Tablet"
        tablet.unitAbbreviation = "tablet"
        tablet.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 22).date!
        saveViewContext()

        let other = Unit(context:  viewContext)
        other.id = UUID()
        other.unitToUnitType = all
        other.unitDescription = "Other"
        other.unitAbbreviation = "other"
        other.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 23).date!
        saveViewContext()

        let kg = Unit(context:  viewContext)
        kg.id = UUID()
        kg.unitToUnitType = met
        kg.unitDescription = "kilogram"
        kg.unitAbbreviation = "kg"
        kg.toImp = 2.2026             //Covert to lb
        kg.toUS = 2.2026
        kg.toImpStr = "lb"
        kg.toUSStr = "lb"
        kg.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 14).date!
        saveViewContext()

        let g = Unit(context:  viewContext)
        g.id = UUID()
        g.unitToUnitType = met
        g.unitDescription = "gram"
        g.unitAbbreviation = "g"
        g.toImp = 0.0353             //Covert to oz
        g.toUS = 0.0353
        g.toImpStr = "oz"
        g.toUSStr = "oz"
        g.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 15).date!
        saveViewContext()

        let lb = Unit(context:  viewContext)
        lb.id = UUID()
        lb.unitToUnitType = imp
        lb.unitDescription = "pounds"
        lb.unitAbbreviation = "lb"
        lb.toMet = 0.454             //Covert to kg
        lb.toMetStr = "kg"
        lb.toUSStr = "lb"
        lb.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 16).date!
        saveViewContext()

        let oz = Unit(context:  viewContext)
        oz.id = UUID()
        oz.unitToUnitType = imp
        oz.unitDescription = "ounces"
        oz.unitAbbreviation = "oz"
        oz.toMet = 28.35            //Covert to g
        oz.toMetStr = "g"
        oz.toUSStr = "oz"
        oz.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 17).date!
        saveViewContext()

        let lbUS = Unit(context:  viewContext)
        lbUS.id = UUID()
        lbUS.unitToUnitType = us
        lbUS.unitDescription = "pounds"
        lbUS.unitAbbreviation = "lb"
        lbUS.toMet = 0.454           //Covert to kg
        lbUS.toMetStr = "kg"
        lbUS.toImpStr = "lb"
        lbUS.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 18).date!
        saveViewContext()

        let ozUS = Unit(context:  viewContext)
        ozUS.id = UUID()
        ozUS.unitToUnitType = us
        ozUS.unitDescription = "ounces"
        ozUS.unitAbbreviation = "oz"
        ozUS.toMet = 28.35          //Covert to g
        ozUS.toMetStr = "g"
        ozUS.toImpStr = "oz"
        ozUS.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 19).date!
        saveViewContext()

        let mg = Unit(context:  viewContext)
        mg.id = UUID()
        mg.unitToUnitType = all
        mg.unitDescription = "miligram"
        mg.unitAbbreviation = "mg"
        mg.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 20).date!
        saveViewContext()

        //-----------------------------------------------//
        //                    BEER                       //
        //-----------------------------------------------//
        var newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Beer"
        newBrewType.picture = UIImage(named: "beerStandard")?.jpegData(compressionQuality: 1.0)
        newBrewType.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 10).date!
        saveViewContext()
        let beerBrewType = newBrewType

        var newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = UIImage(named: "beerStandard")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2009, month: 11, day: 1).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        var newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2,5"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Hops"
        newRecipteItem.amount = "100"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "see instructions"
        newRecipteItem.recipeItemToUnit = other
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Belgian Lager"
        newRecipe.picture = UIImage(named: "belgianLager")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Boil 5 liters of water together with 500g Light Dry Malt in a large saucepan (~ 8 l). Add Hallertau Hersbrucker hops and cook for 5 minutes. Remove the pan from the heat. Put the saucepan in a cold water bath for 15 minutes. Then strain the liquid into the fermenter. Add the beer batch and the malt extract to the fermenter. Stir. Fill with cold water to the mark for 20 liters. Stir. Check the temperature and top up with hot or cold water to reach 23 liters and 18 ° C. Stir. Sprinkle the dry yeast (both bags) over the surface of the fermenter and put on the lid. Place the fermenter away from direct sunlight and leave to ferment at as close to 12-15 ° C as possible. The fermentation should take a total of about 12-20 days. Starting from day 7, measure the density daily. The fermentation is complete when the density is stable over 2 days. The FG value should be about 1008."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 4).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()
        let belgian = newRecipe

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Aromatic"
        newRecipteItem.amount = "200"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Dark Candy"
        newRecipteItem.amount = "200"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Pale Malt"
        newRecipteItem.amount = "2"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Amarilo"
        newRecipteItem.amount = "8"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 5
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: East Kent"
        newRecipteItem.amount = "20"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 6
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Cascade"
        newRecipteItem.amount = "100"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 7
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Liquid yeast"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = packet
        newRecipteItem.sortId = 8
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Easy IPA"
        newRecipe.picture = UIImage(named: "easyipa")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Heat 6 liters of water in a large saucepan to 77 degrees. Crush whole malt if you bought it. Then brush into a bowl gradually. Weigh crushed malt and place in the fermenter. Mashing in: pour on 77 degrees water and stir. Beat in the entire fermenter, even the bottom, in a blanket or blanket and let stand for a total of 90 minutes. Boil water in a kettle or saucepan. Check the temperature which should be 67 degrees every quarter with a thermometer, of course the temperature drops gradually and then you add boiling water and stir and measure the temperature again so that you always have as close to 67 degrees as you can. Then the enzymes in the malt break down the sugar so that it can later ferment to alcohol. Mashing out: in order for the enzymes to stop working, you take out a third of the mash and boil it. Then add to the rest of the mash - then the temperature is raised to about 75-80 degrees. Stir and let stand for 15 minutes. Heat and saucepan with about 3 liters of water to 75-80 degrees on the stove. Prepare to strain the mash. Put a silk in a yeast barrel on a chair. Prepare another yeast barrel next to it with a siphon or hose in between. Take a small saucepan or scoop and catch as much malt as you can and pour in the sieve so that it forms like a filter bed. Continue pouring over the mash and strain it through the sieve. Suck in the siphon so that you get suction in the other fermenter next to it. When you have about 3.5 liters of strained mash (which is now called sweet wort), take it and pour it into a saucepan and heat it to 75-80 degrees. Pour it through the sieve again. In this way, you leach all the sugar out of the malt and the wort becomes shinier (and thus the beer less cloudy). Leach the last sugar from the malt in the silk with about 2-3 liters of extra water that keeps 75-80 degrees. Time to boil the wort with hops: Pour and boil the sweet wort in a large saucepan of about 15-20 liters.  Weigh hops. Calculate how the beers will be (its IBU), ie the amount of hops you will add, according to the formula and the hops' alpha acid (which varies and is stated on the package). The number of IBUs is 3 times below centigrams of alpha acid per liter of wort. The wort should boil for an hour in total. Hops that are put in at the beginning give the most bitterness. Here, hops have been added in three rounds. Add the first batch of Amarillo hops, stir and cook for 40 minutes. Add the second round of East Kent Golding and stir. Cook for another 17 minutes. Add the last batch of hops of Cascade and cook for another 3 minutes. Remove from the heat and strain into a fermenter through a colander. Put the lid on. Allow to cool to room temperature. The wort may stand overnight. Stir in the yeast and ferment with a water trap at room temperature for 10 days. Carefully drop into another fermenter. Boil 3 g of sugar per liter of fermented beer (30 grams to 10 liters) together with a few dl of water (this is so that the sugar dissolves evenly in the beer). Stir in the sugar mixture into the beer. The sugar is added so that it continues to ferment in the bottle and some carbon dioxide is formed. Pour the beer into bottles and put on a cap. Store the beer at room temperature for another 10 days. Cool your IPA before serving."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 5).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Aromatic"
        newRecipteItem.amount = "200"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Dark Candy"
        newRecipteItem.amount = "200"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt: Pale Malt"
        newRecipteItem.amount = "2"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Amarilo"
        newRecipteItem.amount = "8"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 5
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: East Kent"
        newRecipteItem.amount = "20"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 6
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Alpha acid: Cascade"
        newRecipteItem.amount = "100"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 7
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Liquid yeast"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = packet
        newRecipteItem.sortId = 8
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    WINE                       //
        //-----------------------------------------------//
        newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Wine"
        newBrewType.picture = UIImage(named: "wineStandard")?.jpegData(compressionQuality: 1.0)
        newBrewType.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 9).date!
        saveViewContext()
        let wineBrewType = newBrewType

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = UIImage(named: "wineStandard")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 1998, month: 11, day: 1).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Fruit"
        newRecipteItem.amount = "6"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "8"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,8"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Wine yeast"
        newRecipteItem.amount = "see instructions"
        newRecipteItem.recipeItemToUnit = other
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Pear wine"
        newRecipe.picture = UIImage(named: "pearWine")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Dice pears, with peel and core, mix with rowanberries in a wine damejeanne or ice bucket. Add lukewarm water (ideal temperature 25-30 degrees), vitamin B, yeast nutrient and yeast. Stir and let stand for 3 days. Strain off the fruit remains. Mix in the sugar and stir until dissolved. Adjust to 10 liters volume with lukewarm water and let the wine ferment for a few more days. The sugar content must have dropped significantly. Taste it too. Redraw it to a new vessel without the bottom set. After a few days, you can finish the fermentation with a little Campden powder to be sure that it does not continue to ferment after bottling."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 3).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Pears"
        newRecipteItem.amount = "6"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Rowan berries"
        newRecipteItem.amount = "0,5"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "8"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,8"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Campden powder"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 5
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "B-vitamin"
        newRecipteItem.amount = "6"
        newRecipteItem.recipeItemToUnit = mg
        newRecipteItem.sortId = 6
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast nutrient"
        newRecipteItem.amount = "3"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 7
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Wine yeast"
        newRecipteItem.amount = "see instructions"
        newRecipteItem.recipeItemToUnit = other
        newRecipteItem.sortId = 8
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Apple wine"
        newRecipe.picture = UIImage(named: "AppleWineRecipe2x")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Dice apples, with peel and core, mix with rowanberries in a wine damejeanne or ice bucket. Add lukewarm water (ideal temperature 25-30 degrees), vitamin B, yeast nutrient and yeast. Stir and let stand for 3 days. Strain off the fruit remains. Mix in the sugar and stir until dissolved. Adjust to 10 liters volume with lukewarm water and let the wine ferment for a few more days. The sugar content must have dropped significantly. Taste it too. Redraw it to a new vessel without the bottom set. After a few days, you can finish the fermentation with a little Campden powder to be sure that it does not continue to ferment after bottling."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 7).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()
        let appleWine = newRecipe

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Apples"
        newRecipteItem.amount = "6"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Rowan berries"
        newRecipteItem.amount = "0,5"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "8"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,8"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Campden powder"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 5
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "B-vitamin"
        newRecipteItem.amount = "6"
        newRecipteItem.recipeItemToUnit = mg
        newRecipteItem.sortId = 6
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast nutrient"
        newRecipteItem.amount = "3"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 7
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Wine yeast"
        newRecipteItem.amount = "see instructions"
        newRecipteItem.recipeItemToUnit = other
        newRecipteItem.sortId = 8
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    CIDER                      //
        //-----------------------------------------------//
        newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Cider"
        newBrewType.picture = UIImage(named: "cidetStandard")?.jpegData(compressionQuality: 1.0)
        newBrewType.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 8).date!
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = UIImage(named: "cidetStandard")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = us
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 1998, month: 10, day: 1).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Apples"
        newRecipteItem.amount = "15"
        newRecipteItem.recipeItemToUnit = lbUS
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = cup
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = packet
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Basic Apple"
        newRecipe.picture = UIImage(named: "appleCider")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = imp
        newRecipe.instructions = "Pour the juice into a sanitized fermentation bucket. Check and record the original gravity. (If using unpasteurized juice, crush the Campden tablet[s] and whisk into the juice; snap on the lid, insert an air lock filled with sanitizer or vodka, and let the juice stand for 24 hours.) Sprinkle the yeast, pectic enzyme, and yeast nutrient over the juice. Whisk vigorously with a sanitized whisk to dissolve the ingredients and aerate the juice. Snap on the lid and insert a filled air lock. Place the bucket out of direct sunlight and at room temperature (70° to 75ºF). Fermentation should begin within 24 hours (bubbles will pop regularly through the air lock). Active fermentation will peak after a few days, then gradually finish within 1 to 2 weeks. Once you’ve seen very little activity in the air lock for a few days (a stray bubble or two is fine), siphon the cider to a sanitized jug or carboy, leaving behind as much sediment as possible. As you transfer the cider, taste it using a sanitized wine thief to check its progress. Insert the stopper and air lock, then place the cider out of direct sunlight and at room temperature for another 2 weeks or up to 2 months. When ready to bottle, taste the cider again. If needed, add acid blend for more acidity or tannin for more astringency. Taste again a few days later, and continue adjusting and tasting until you’re happy. Check the final gravity and calculate the ABV. Dissolve the corn sugar in the hot water and mix with the cider, back-sweetening if desired. Bottle the cider. Wait 2 weeks before drinking or store for up to a year. Serve chilled."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 6).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Apple Juice"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = gallon
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Campden Powder"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = tablet
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Cider Yeast"
        newRecipteItem.amount = "1/2"
        newRecipteItem.recipeItemToUnit = packet
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Pectic Enzyme Powder"
        newRecipteItem.amount = "1/2"
        newRecipteItem.recipeItemToUnit = teaSpoon
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast Nutrient"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = packet
        newRecipteItem.sortId = 5
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Powdered Acid Blend"
        newRecipteItem.amount = "1/2"
        newRecipteItem.recipeItemToUnit = teaSpoon
        newRecipteItem.sortId = 6
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Powdered Wine Tannin"
        newRecipteItem.amount = "1/8"
        newRecipteItem.recipeItemToUnit = teaSpoon
        newRecipteItem.sortId = 7
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Corn Sugar, for bottling"
        newRecipteItem.amount = "3"
        newRecipteItem.recipeItemToUnit = tableSpoon
        newRecipteItem.sortId = 8
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    MEAD                       //
        //-----------------------------------------------//
        newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Mead"
        newBrewType.picture = UIImage(named: "meadStandard")?.jpegData(compressionQuality: 1.0)
        newBrewType.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 7).date!
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = UIImage(named: "meadStandard")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 1997, month: 9, day: 2).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Honey"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "see instructions"
        newRecipteItem.recipeItemToUnit = other
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Viking Mead"
        newRecipe.picture = UIImage(named: "meadRecipe")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Heat about 2 liters of water, dissolve the honey and malt. Cook. Let boil for 45 minutes. Pour 10 liters of cold water into the ice bucket. Pour on the brew, fill with water to the 20 liter mark. Add the yeast and stir. Leave with a towel over. When foam has formed on the surface, takes about a day, the fermentation has begun. Add 5 dl sugar and stir. After another two days, add 1 kg of sugar and 2 liters of water. When the fermentation starts to slow down, add the rest of the sugar and water. After another three weeks when the mead is completely fermented. Fill it in a Carboy.."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 1).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2,5"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Honey"
        newRecipteItem.amount = "4"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "2,5"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = packet
        newRecipteItem.sortId = 5
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    OTHER                      //
        //-----------------------------------------------//
        newBrewType = BrewType(context: viewContext)
        newBrewType.id = UUID()
        newBrewType.typeDescription = "Other"
        newBrewType.picture = UIImage(named: "otherStandard")?.jpegData(compressionQuality: 1.0)
        newBrewType.timestamp = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 6).date!

        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Standard"
        newRecipe.picture = UIImage(named: "otherStandard")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "6"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Juniper"
        newRecipteItem.amount = "1"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "see instructions"
        newRecipteItem.recipeItemToUnit = other
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = "Dricku"
        newRecipe.picture = UIImage(named: "dricku2")?.jpegData(compressionQuality: 1.0)
        newRecipe.recipeToUnitType = met
        newRecipe.instructions = "Use this if you don't care about keeping track of recipies."
        newRecipe.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 1, day: 2).date!
        newRecipe.recipeToBrewType = newBrewType
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Malt"
        newRecipteItem.amount = "2,5"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 1
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Water"
        newRecipteItem.amount = "10"
        newRecipteItem.recipeItemToUnit = litre
        newRecipteItem.sortId = 2
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Hops"
        newRecipteItem.amount = "50"
        newRecipteItem.recipeItemToUnit = g
        newRecipteItem.sortId = 3
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Sugar"
        newRecipteItem.amount = "6"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 4
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Brown Sugar"
        newRecipteItem.amount = "2"
        newRecipteItem.recipeItemToUnit = kg
        newRecipteItem.sortId = 5
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Juniper"
        newRecipteItem.amount = "2-3 branches"
        newRecipteItem.recipeItemToUnit = other
        newRecipteItem.sortId = 6
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        newRecipteItem = RecipeItem(context: viewContext)
        newRecipteItem.id = UUID()
        newRecipteItem.itemDescription = "Yeast"
        newRecipteItem.amount = "1/4"
        newRecipteItem.recipeItemToUnit = packet
        newRecipteItem.sortId = 7
        newRecipteItem.recipeItemToRecipe = newRecipe
        saveViewContext()

        //-----------------------------------------------//
        //                    Brew                       //
        //-----------------------------------------------//
        var newBrew = Brew(context: viewContext)
        newBrew.id = UUID()
        newBrew.name = "My first Beer"
        newBrew.picture = UIImage(named: "myBeer1")?.jpegData(compressionQuality: 1.0)
        newBrew.isDone = true
        newBrew.grade = 2
        newBrew.finalGravity = 1005
        newBrew.start = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 1).date
        newBrew.eta = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 21).date
        newBrew.originalGravity = 1075
        newBrew.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 1).date
        newBrew.brewToBrewType = beerBrewType
        newBrew.brewToRecipe = belgian
        saveViewContext()
        
        var newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 5).date
        newBrewCheck.comment = "Just a peek"
        newBrewCheck.gravity = 1040
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 5).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()

        newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 12).date
        newBrewCheck.comment = "Change bucket"
        newBrewCheck.gravity = 1030
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 12).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()

        newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 19).date
        newBrewCheck.comment = "Added acid to stop fermenting"
        newBrewCheck.gravity = 1010
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 19).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()

        newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 20).date
        newBrewCheck.comment = "Botteling"
        newBrewCheck.gravity = 1005
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 20).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()

        newBrew = Brew(context: viewContext)
        newBrew.id = UUID()
        newBrew.name = "My first Applewine"
        newBrew.picture = UIImage(named: "myAppleWine1")?.jpegData(compressionQuality: 1.0)
        newBrew.isDone = false
        newBrew.start = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 1).date
        newBrew.eta = DateComponents(calendar: Calendar.current, year: 2021, month: 3, day: 5).date
        newBrew.originalGravity = 1095
        newBrew.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 1).date
        newBrew.brewToBrewType = wineBrewType
        newBrew.brewToRecipe = appleWine
        saveViewContext()
        
        newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 5).date
        newBrewCheck.comment = "Just a peek"
        newBrewCheck.gravity = 1040
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 5).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()

        newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 12).date
        newBrewCheck.comment = "Change bucket"
        newBrewCheck.gravity = 1025
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 12).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()

        newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 19).date
        newBrewCheck.comment = "Added acid to stop fermenting"
        newBrewCheck.gravity = 1005
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 19).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()

        newBrewCheck = BrewCheck(context: viewContext)
        newBrewCheck.id = UUID()
        newBrewCheck.date = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 20).date
        newBrewCheck.comment = "Botteling"
        newBrewCheck.gravity = 990
        newBrewCheck.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 20).date
        newBrewCheck.brewCheckToBrew = newBrew
        saveViewContext()
    
        //-----------------------------------------------//
        //                 Wine Cellar                   //
        //-----------------------------------------------//
        
        var newStorage = WineCellar(context: viewContext)
        newStorage.id = UUID()
        newStorage.picture = UIImage(named: "wineStore1")?.jpegData(compressionQuality: 1.0)
        newStorage.name = "Applewine storage first try"
        newStorage.comment = "This wine was a bit sweet at the begining"
        newStorage.start = DateComponents(calendar: Calendar.current, year: 2017, month: 3, day: 1).date
        newStorage.bottlesStart = 12
        newStorage.isNotDrunk = true
        newStorage.timestamp = DateComponents(calendar: Calendar.current, year: 2017, month: 3, day: 1).date
        newStorage.wineCellarToBrew = newBrew
        newStorage.qrID = newBrew.id
        saveViewContext()
    
        var newTaste = Taste(context: viewContext)
        newTaste.id = UUID()
        newTaste.date = DateComponents(calendar: Calendar.current, year: 2018, month: 3, day: 1).date
        newTaste.bottles = 1
        newTaste.comment = "Needs a alot more time..."
        newTaste.rate = 1
        newTaste.timestamp = DateComponents(calendar: Calendar.current, year: 2018, month: 3, day: 1).date
        newTaste.tasteToWineCellar = newStorage
        saveViewContext()

        newTaste = Taste(context: viewContext)
        newTaste.id = UUID()
        newTaste.date = DateComponents(calendar: Calendar.current, year: 2019, month: 3, day: 1).date
        newTaste.bottles = 2
        newTaste.comment = "After two years its actually decent"
        newTaste.rate = 3
        newTaste.timestamp = DateComponents(calendar: Calendar.current, year: 2019, month: 3, day: 1).date
        newTaste.tasteToWineCellar = newStorage
        saveViewContext()

        newTaste = Taste(context: viewContext)
        newTaste.id = UUID()
        newTaste.date = DateComponents(calendar: Calendar.current, year: 2020, month: 3, day: 1).date
        newTaste.bottles = 3
        newTaste.comment = "Big, big difference! Peftect level of sweetness. I wonder if the wine has peeked?"
        newTaste.rate = 4
        newTaste.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 3, day: 1).date
        newTaste.tasteToWineCellar = newStorage
        saveViewContext()

        newStorage = WineCellar(context: viewContext)
        newStorage.picture = UIImage(named: "winestore2")?.jpegData(compressionQuality: 1.0)
        newStorage.id = UUID()
        newStorage.name = "Sauvignon from Moldova"
        newStorage.comment = "A Cabernet Sauvignon from Moldova which I got hold of."
        newStorage.start = DateComponents(calendar: Calendar.current, year: 2019, month: 3, day: 1).date
        newStorage.bottlesStart = 12
        newStorage.isNotDrunk = true
        newStorage.timestamp = DateComponents(calendar: Calendar.current, year: 2019, month: 3, day: 1).date
        newStorage.wineCellarToBrew = nil
        newStorage.qrID = UUID()
        saveViewContext()
    
        newTaste = Taste(context: viewContext)
        newTaste.id = UUID()
        newTaste.date = DateComponents(calendar: Calendar.current, year: 2020, month: 3, day: 1).date
        newTaste.bottles = 4
        newTaste.comment = "Well, it was good at start and it taste more or less the same now."
        newTaste.rate = 3
        newTaste.timestamp = DateComponents(calendar: Calendar.current, year: 2020, month: 3, day: 1).date
        newTaste.tasteToWineCellar = newStorage
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
