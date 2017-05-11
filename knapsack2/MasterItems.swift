//
//  MasterItems.swift
//  knapsack
//
//  Created by Timothy Ludi on 8/1/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import Foundation

struct CategoryList {
  var category: String
  var items: [String]
}


class MasterItemList {

  let categories: [String] = [
    "camping",
    "clothing",
    "documents",
    "electronics",
    "financial",
    "food",
    "medical",
    "miscellaneous",
    "toiletries",
//    "international",
//    "beach",
//    "hiking",
//    "children",
//    "infants",
//    "carry on luggage"
  ]

  let itemList: [String:[String]] = [
    "camping": [
      "Camp Shovel",
      "Camp Stove",
      "Cooler",
      "Firewood",
      "Foam Pad",
      "Matches",
      "Propane",
      "Sleeping Bag",
      "Tarp",
      "Tent"
    ],
    "clothing": [
      "Belts",
      "Bras",
      "Casual Pants",
      "Casual Shirts",
      "Dress Pants",
      "Dress Shirts",
      "Dress Shoes",
      "Dresses",
      "Gloves",
      "Hats",
      "Jackets/Coats",
      "Pajamas",
      "Robe",
      "Sandals",
      "Scarves",
      "Shorts",
      "Skirts",
      "Slippers",
      "Socks",
      "Sport Coats",
      "Suits",
      "Sweaters",
      "Swimwear",
      "T-Shirts",
      "Tennis Shoes",
      "Ties",
      "Underwear",
      "Workout Clothes"
    ],
    "documents": [
      "Boarding Pass",
      "Business Cards",
      "Drivers License/ID",
      "Guide Books",
      "Hotel Reservations",
      "Maps",
      "Notebooks/Pens",
      "Passport",
      "Reading Books",
      "Tickets",
      "Travel Itinerary",
      "Visa",
    ],
    "electronics": [
      "Batteries",
      "Camera",
      "Cellphone",
      "Cellphone Charger",
      "Exercise Monitor",
      "Exercise Monitor Charger",
      "Headphones",
      "Laptop",
      "Memory Card",
      "Mouse",
      "Music",
      "Tablet",
      "Tablet Charger",
      "Watch"
    ],
    "financial": [
      "Cash",
      "Credit Card",
      "Company Credit Card",
      "Debit Card",
      "Purse",
      "Wallet",
    ],
    "food": [
      "Dried Fruit",
      "Granola Bars",
      "Nuts",
      "Oatmeal Packets",
      "Protein Bars",
      "Water"
    ],
    "medical": [
      "Allergy Medication",
      "Eye Drops",
      "First Aid Kit",
      "Hand Sanitizer",
      "Hand Wipes",
      "Motion Sickness Medication",
      "Pain Medication",
      "Prescriptions",
      "Vitamins"
    ],
    "miscellaneous": [
      "Earplugs",
      "Keys",
      "Travel Iron",
      "Travel Locks",
      "Umbrella"
    ],
    "toiletries": [
      "Aftershave",
      "Bar Soap",
      "Brush/Comb",
      "Cologne",
      "Conditioner",
      "Cosmetics",
      "Cotton Balls",
      "Cotton Swabs",
      "Curling Iron",
      "Dental Floss/Picks",
      "Deodorant",
      "Feminine Products",
      "Hair Accessories",
      "Hair Dryer",
      "Hair Spray",
      "Lip Balm",
      "Lotion",
      "Mirror",
      "Mouthwash/Rinse",
      "Nail Clippers",
      "Perfume",
      "Razor",
      "Shampoo",
      "Shaving Cream/Gel",
      "Tissues",
      "Toothbrush",
      "Toothpaste",
      "Tweezers",
      "Washcloth",
    ]

  ] // end itemList

}







