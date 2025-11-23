local foods = require("soultide.foods") --得到table 而不是prefabs --DST中require从script开始

for k,recipe in pairs (foods) do
	AddCookerRecipe("cookpot", recipe, true) --是mod食物
	AddCookerRecipe("portablecookpot", recipe ,true)
	AddCookerRecipe("archive_cookpot", recipe ,true)

	if recipe.card_def then
		AddRecipeCard("cookpot", recipe)
	end
end