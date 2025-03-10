import 'package:firfir_tera/Domain/Repository%20Interface/recipe_repositery.dart';
import 'package:firfir_tera/application/bloc/auth/auth_bloc.dart';
import 'package:firfir_tera/application/bloc/auth/auth_state.dart';
import 'package:firfir_tera/Domain/Entities/recipe.dart';
import 'package:firfir_tera/presentation/pages/comment/screen/comment.dart';
import 'package:firfir_tera/presentation/pages/recipe/screen/edit_recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DetailedView extends StatefulWidget {
  final String recipeId;

  DetailedView({super.key, required this.recipeId});

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  final RecipeRepository _recipeRepository = RecipeRepository();
  late Future<Recipe> futureRecipe;
  String? userId;

  @override
  void initState() {
    super.initState();
    futureRecipe = _recipeRepository.fetchRecipe(widget.recipeId!);
    userId = context.read<AuthBloc>().state.userId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        key: const Key('detailed_recipe_page'),
        future: futureRecipe,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading spinner while waiting
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    key: const Key('detailed_recipe_back_button'),
                    onPressed: () {
                      context.goNamed("/home");
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: const Text('Recipe Details'),
                ),
                body: Center(
                    child: Text(
                        'Error: ${snapshot.error}'))); // Show error message if something went wrong
          } else {
            Recipe recipe = snapshot.data!;
            return Scaffold(
                body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SafeArea(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                context.goNamed("/home");
                                              },
                                              icon:
                                                  const Icon(Icons.arrow_back),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  recipe.name, //recipe name
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          key: const Key('comment_button'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                print(recipe.id);

                                                return CommentScreen(
                                                    recipeId: recipe.id!);
                                              }),
                                            );
                                          },
                                          icon: const Icon(Icons.comment),
                                        ),
                                        if (userId == recipe.cookId)
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return EditRecipe(
                                                      recipe: recipe);
                                                }),
                                              );
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                        if (userId == recipe.cookId)
                                          IconButton(
                                              onPressed: () async {
                                                final confirm =
                                                    await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title:
                                                        const Text('Confirm'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this recipe?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true),
                                                        child: Text('Yes'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: Text('No'),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (confirm) {
                                                  // Send the delete request
                                                  // Replace this with your actual delete request code
                                                  try {
                                                    await _recipeRepository
                                                        .deleteRecipe(
                                                            recipe.id!);
                                                    context.goNamed("/home");
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Failed to delete recipe: $e'),
                                                    ));
                                                  }
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: recipe.image.startsWith('http')
                                              ? NetworkImage(recipe.image)
                                              : AssetImage(recipe.image)
                                                  as ImageProvider,
                                          fit: BoxFit.cover // recipe image
                                          ),
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(Icons.timer),
                                        Text('${recipe.cookTime} min' //cookTime
                                            )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(Icons.person_3),
                                        Text("${recipe.people}" //rating
                                            )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(Icons.food_bank),
                                        Text(recipe.fasting),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Ingredients",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: recipe.ingredients.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        recipe.ingredients[index],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Steps",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: recipe.steps.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        recipe.steps[index],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))));
          }
        }));
  }
}
