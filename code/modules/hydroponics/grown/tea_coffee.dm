// Tea
/obj/item/seeds/tea
    name = "pack of tea aspera seeds"
    desc = "These seeds grow into tea plants."
    icon_state = "seed-teaaspera"
    species = "teaaspera"
    plantname = "Tea Aspera Plant"
    product = /obj/item/reagent_containers/food/snacks/grown/tea
    lifespan = 20
    maturation = 5
    production = 5
    yield = 5
    growthstages = 5
    icon_dead = "tea-dead"
    genes = list(/datum/plant_gene/trait/repeated_harvest)
    mutatelist = list(/obj/item/seeds/tea/astra)
    reagents_add = list("vitamin" = 0.04, "teapowder" = 0.1)

/obj/item/reagent_containers/food/snacks/grown/tea
    seed = /obj/item/seeds/tea
    name = "Tea Aspera tips"
    desc = "These aromatic tips of the tea plant can be dried to make tea."
    icon_state = "tea_aspera_leaves"
    tastes = list("tea leaves" = 1)
    filling_color = "#008000"
    can_distill = FALSE

// Tea Astra
/obj/item/seeds/tea/astra
    name = "pack of tea astra seeds"
    icon_state = "seed-teaastra"
    desc = "These seeds grow into Tea Astra, a more potent variant of tea"
    species = "teaastra"
    plantname = "Tea Astra Plant"
    product = /obj/item/reagent_containers/food/snacks/grown/tea/astra
    mutatelist = list()
    reagents_add = list("synaptizine" = 0.1, "vitamin" = 0.04, "teapowder" = 0.1)
    rarity = 20

/obj/item/reagent_containers/food/snacks/grown/tea/astra
    seed = /obj/item/seeds/tea/astra
    name = "Tea Astra tips"
    desc = "Knock away your fatigue!"
    icon_state = "tea_astra_leaves"
    tastes = list("tea leaves" = 1, "pure energy" = 1)
    filling_color = "#4582B4"


// Coffee
/obj/item/seeds/coffee
    name = "pack of coffee arabica seeds"
    desc = "These seeds grow into coffee arabica bushes."
    icon_state = "seed-coffeea"
    species = "coffeea"
    plantname = "Coffee Arabica Bush"
    product = /obj/item/reagent_containers/food/snacks/grown/coffee
    lifespan = 30
    endurance = 20
    maturation = 5
    production = 5
    yield = 5
    growthstages = 5
    icon_dead = "coffee-dead"
    genes = list(/datum/plant_gene/trait/repeated_harvest)
    mutatelist = list(/obj/item/seeds/coffee/robusta)
    reagents_add = list("vitamin" = 0.04, "coffeepowder" = 0.1)

/obj/item/reagent_containers/food/snacks/grown/coffee
    seed = /obj/item/seeds/coffee
    name = "coffee arabica beans"
    desc = "Dry them out to make coffee."
    icon_state = "coffee_arabica"
    filling_color = "#DC143C"
    tastes = list("coffee beans" = 1)
    bitesize_mod = 2
    distill_reagent = "kahlua"

// Coffee Robusta
/obj/item/seeds/coffee/robusta
    name = "pack of coffee robusta seeds"
    desc = "These seeds grow into coffee robusta bushes."
    icon_state = "seed-coffeer"
    species = "coffeer"
    plantname = "Coffee Robusta Bush"
    product = /obj/item/reagent_containers/food/snacks/grown/coffee/robusta
    mutatelist = list()
    reagents_add = list("ephedrine" = 0.1, "vitamin" = 0.04, "coffeepowder" = 0.1)
    rarity = 20

/obj/item/reagent_containers/food/snacks/grown/coffee/robusta
    seed = /obj/item/seeds/coffee/robusta
    name = "coffee robusta beans"
    desc = "Increases robustness by 37 percent!"
    tastes = list("coffee beans" = 1, "robustness" = 1)
    icon_state = "coffee_robusta"
