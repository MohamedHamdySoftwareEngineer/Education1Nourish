import 'package:edunourish/features/student/screens/list/profile_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edunourish/features/student/providers/student_provider.dart';
import 'package:edunourish/core/models/food_palce.dart';

class FoodPlaceScreen extends StatefulWidget {
  const FoodPlaceScreen({super.key});

  @override
  State<FoodPlaceScreen> createState() => _FoodPlaceScreenState();
}

class _FoodPlaceScreenState extends State<FoodPlaceScreen>
    with SingleTickerProviderStateMixin {
  String searchText = '';

  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 7),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<StudentProvider>();

    if (prov.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final allPlaces = prov.foodPlace;
    final filtered = allPlaces.where((p) {
      final q = searchText.toLowerCase();
      return (p.name?.toLowerCase().contains(q) ?? false) ||
          (p.description?.toLowerCase().contains(q) ?? false);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xffc4e9ec),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with highlighted word
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Discover ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextSpan(
                            text: 'Delicious ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextSpan(
                            text: 'Meals',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      'Culinary masterpieces crafted with passion and precision',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Color(0xff171d21),
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 20),
                    // Search field
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          onChanged: (v) => setState(() => searchText = v),
                          decoration: const InputDecoration(
                            hintText: "Search dishes, healthy food...",
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: Icon(Icons.mic),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                        )),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filtered.isEmpty
                    ? _buildNoResults()
                    : GridView.builder(
                        itemCount: filtered.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (_, i) {
                          final place = filtered[i];
                          return SlideTransition(
                            position: _slideAnim,
                            child: _buildPlaceCard(place),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const Text("Food Place",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreenStudent()),
            ),
            child: const Image(
              image: AssetImage('assets/Intro_Screen_login/EduIcon.png'),
              height: 50,
              width: 50,
            ),
          ),
        ],
      );

  Widget _buildSearchField() => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          onChanged: (v) => setState(() => searchText = v),
          decoration: const InputDecoration(
            hintText: "Search dishes, restaurants...",
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.mic),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
          ),
        ),
      );

  Widget _buildNoResults() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'No restaurants found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildPlaceCard(FoodPlace place) => InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showPlaceDetails(place),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    place.photo ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  place.name ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  place.description ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );

  void _showPlaceDetails(FoodPlace place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final h = MediaQuery.of(context).size.height * 0.7;
        return SizedBox(
          height: h,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xff008f99),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            place.photo ?? '',
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.error, size: 80, color: Colors.red),
                          ),
                        ),
                          const SizedBox(height: 16),
                    Text(
                      place.name ?? '',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      place.description ?? '',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              
              ],
            ),
          ),
        );
      },
    );
  }
}
