# frozen_string_literal: true

# Ingredients
## Tea
white_tea  = Ingredient.find_or_create_by(name: 'White Tea', base: true, caffeine_free: true, vegan: true)
black_tea  = Ingredient.find_or_create_by(name: 'Black Tea', base: true, caffeine_free: false, vegan: true)
green_tea  = Ingredient.find_or_create_by(name: 'Green Tea', base: true, caffeine_free: false, vegan: true)
oolong_tea = Ingredient.find_or_create_by(name: 'Oolong Tea', base: true, caffeine_free: false, vegan: true)

## Fun stuff
vanilla         = Ingredient.find_or_create_by(name: 'Vanilla', base: false, caffeine_free: true, vegan: true)
ginger          = Ingredient.find_or_create_by(name: 'Ginger', base: false, caffeine_free: true, vegan: true)
hibiscus        = Ingredient.find_or_create_by(name: 'Hibiscus', base: false, caffeine_free: true, vegan: true)
spearmint       = Ingredient.find_or_create_by(name: 'Spearmint', base: false, caffeine_free: true, vegan: true)
lemongrass      = Ingredient.find_or_create_by(name: 'Lemongress', base: false, caffeine_free: true, vegan: true)
peppermint      = Ingredient.find_or_create_by(name: 'Peppermint', base: false, caffeine_free: true, vegan: true)
rose_petal      = Ingredient.find_or_create_by(name: 'Rose Petal', base: false, caffeine_free: true, vegan: true)
tulip           = Ingredient.find_or_create_by(name: 'Tulip', base: false, caffeine_free: true, vegan: true)
chocolate       = Ingredient.find_or_create_by(name: 'Chocolate', base: false, caffeine_free: false, vegan: true)
mandarin_orange = Ingredient.find_or_create_by(name: 'Mandorin Orange', base: false, caffeine_free: false, vegan: true)
coffee          = Ingredient.find_or_create_by(name: 'Coffee', base: false, caffeine_free: false, vegan: true)
concord_grape   = Ingredient.find_or_create_by(name: 'Concord Grape', base: false, caffeine_free: true, vegan: true)
mango           = Ingredient.find_or_create_by(name: 'Mango', base: false, caffeine_free: true, vegan: true)
guava           = Ingredient.find_or_create_by(name: 'Guava', base: false, caffeine_free: true, vegan: true)
banana          = Ingredient.find_or_create_by(name: 'Banana', base: false, caffeine_free: true, vegan: true)
pineapple       = Ingredient.find_or_create_by(name: 'Pineapple', base: false, caffeine_free: true, vegan: true)
dragon_fruit    = Ingredient.find_or_create_by(name: 'Guava', base: false, caffeine_free: true, vegan: true)
avacado         = Ingredient.find_or_create_by(name: 'Avacado', base: false, caffeine_free: true, vegan: true)
bacon           = Ingredient.find_or_create_by(name: 'Bacon', base: false, caffeine_free: true, vegan: false)
sausage         = Ingredient.find_or_create_by(name: 'Sausage', base: false, caffeine_free: true, vegan: false)
ham             = Ingredient.find_or_create_by(name: 'Ham', base: false, caffeine_free: true, vegan: false)
pepperoni       = Ingredient.find_or_create_by(name: 'Pepperoni', base: false, caffeine_free: true, vegan: false)
mozzarella      = Ingredient.find_or_create_by(name: 'Mozzarella', base: false, caffeine_free: true, vegan: false)
tabasco         = Ingredient.find_or_create_by(name: 'Tobasco', base: false, caffeine_free: true, vegan: true)
green_olive     = Ingredient.find_or_create_by(name: 'Green Olive', base: false, caffeine_free: true, vegan: true)
broccoli        = Ingredient.find_or_create_by(name: 'Broccoli', base: false, caffeine_free: true, vegan: true)
worschestire    = Ingredient.find_or_create_by(name: 'Worchestire', base: false, caffeine_free: true, vegan: true)
clamato         = Ingredient.find_or_create_by(name: 'Clamato', base: false, caffeine_free: true, vegan: false)
sriracha        = Ingredient.find_or_create_by(name: 'Sriracha', base: false, caffeine_free: true, vegan: true)
beer            = Ingredient.find_or_create_by(name: 'Beer', base: false, caffeine_free: true, vegan: true)
redbull         = Ingredient.find_or_create_by(name: 'Redbull', base: false, caffeine_free: false, vegan: false)

sample = -> { [*1..10].sample }

# Kombuchas
guinny_pop = Kombucha.find_or_create_by(name: 'Guinny Pop', fizziness_level: 'low')
[black_tea, vanilla, mandarin_orange, rose_petal].each do |ingredient|
  guinny_pop.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

pork_pop = Kombucha.find_or_create_by(name: 'Pork Pop', fizziness_level: 'medium')
[oolong_tea, bacon, sausage, ham].each do |ingredient|
  pork_pop.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

breathyzer = Kombucha.find_or_create_by(name: 'Breathalyzer', fizziness_level: 'medium')
[white_tea, spearmint, peppermint, ginger].each do |ingredient|
  breathyzer.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

wobbly_pop = Kombucha.find_or_create_by(name: 'Wobbly pop', fizziness_level: 'high')
[green_tea, beer, ginger, vanilla].each do |ingredient|
  wobbly_pop.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

pizza_pop = Kombucha.find_or_create_by(name: 'Pizza pop', fizziness_level: 'low')
[black_tea, bacon, pepperoni, mozzarella].each do |ingredient|
  pizza_pop.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

tropical_party = Kombucha.find_or_create_by(name: 'Tropical Burst', fizziness_level: 'low')
[oolong_tea, mango, guava, dragon_fruit].each do |ingredient|
  tropical_party.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

spicy_sting = Kombucha.find_or_create_by(name: 'Spicy Sting', fizziness_level: 'high')
[white_tea, clamato, sriracha, tabasco].each do |ingredient|
  spicy_sting.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

dark_and_stormy = Kombucha.find_or_create_by(name: 'Dark & Stormy', fizziness_level: 'medium')
[black_tea, ginger, chocolate, mandarin_orange].each do |ingredient|
  dark_and_stormy.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

amped_up = Kombucha.find_or_create_by(name: 'Amped Up', fizziness_level: 'high')
[green_tea, redbull, vanilla, ginger].each do |ingredient|
  amped_up.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end

froot_punch = Kombucha.find_or_create_by(name: 'Froot Punch', fizziness_level: 'medium')
[white_tea, concord_grape, banana, pineapple].each do |ingredient|
  froot_punch.recipe_items.find_or_create_by(ingredient_id: ingredient.id, amount: sample.call)
end
