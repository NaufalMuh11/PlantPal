import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plants_app/constants.dart';
import 'package:plants_app/model/plants.dart';
import 'package:plants_app/ui/screens/detail_page.dart';
import 'package:plants_app/ui/screens/widget/plant_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Plant> _plantList = Plant.plantList;
  List<Plant> _filteredPlantList =
      Plant.plantList; // List yang akan ditampilkan

  //Plants category
  List<String> _plantTypes = [
    'Recommended',
    'Indoor',
    'Outdoor',
    'Garden',
    'Supplement',
  ];

  // Fungsi untuk filter tanaman berdasarkan kategori
  void _filterPlants(String category) {
    setState(() {
      if (category == 'Recommended') {
        _filteredPlantList =
            _plantList
                .where((plant) => plant.category == 'Recommended')
                .toList();
      } else if (category == 'Indoor') {
        _filteredPlantList =
            _plantList.where((plant) => plant.category == 'Indoor').toList();
      } else if (category == 'Outdoor') {
        _filteredPlantList =
            _plantList.where((plant) => plant.category == 'Outdoor').toList();
      } else if (category == 'Garden') {
        _filteredPlantList =
            _plantList.where((plant) => plant.category == 'Garden').toList();
      } else if (category == 'Supplement') {
        _filteredPlantList =
            _plantList
                .where((plant) => plant.category == 'Supplement')
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //Toggle Favorite Button
    bool toggleIsFavorated(bool isFavorited) {
      return !isFavorited;
    }

    return Scaffold(
      body: Column(
        children: [
          // BAGIAN ATAS - FIXED/STICKY
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        width: size.width * .9,
                        decoration: BoxDecoration(
                          color: Constants.primaryColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.black54.withOpacity(.6),
                            ),
                            const Expanded(
                              child: TextField(
                                showCursor: false,
                                decoration: InputDecoration(
                                  hintText: 'Search Plant',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.mic,
                              color: Colors.black54.withOpacity(.6),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Categories dengan fungsi filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 50.0,
                  width: size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _plantTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            // Filter tanaman berdasarkan kategori yang dipilih
                            _filterPlants(_plantTypes[index]);
                          },
                          child: Text(
                            _plantTypes[index],
                            style: TextStyle(
                              color:
                                  selectedIndex == index
                                      ? Constants.primaryColor
                                      : Constants.blackColor,
                              fontSize: 16.0,
                              fontWeight:
                                  selectedIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.w300,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Horizontal Plant List (menggunakan filtered list)
                SizedBox(
                  height: size.height * .3,
                  child:
                      _filteredPlantList.isEmpty
                          ? const Center(
                            child: Text(
                              'No plants found in this category',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: _filteredPlantList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: DetailPage(
                                        plantId:
                                            _filteredPlantList[index].plantId,
                                      ),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Constants.primaryColor.withOpacity(
                                      .8,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 10,
                                        right: 20,
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                bool isFavorited =
                                                    toggleIsFavorated(
                                                      _filteredPlantList[index]
                                                          .isFavorated,
                                                    );
                                                _filteredPlantList[index]
                                                    .isFavorated = isFavorited;

                                                // Update juga di list utama
                                                int originalIndex = _plantList
                                                    .indexWhere(
                                                      (plant) =>
                                                          plant.plantId ==
                                                          _filteredPlantList[index]
                                                              .plantId,
                                                    );
                                                if (originalIndex != -1) {
                                                  _plantList[originalIndex]
                                                          .isFavorated =
                                                      isFavorited;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              _filteredPlantList[index]
                                                          .isFavorated ==
                                                      true
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Constants.primaryColor,
                                            ),
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 50,
                                        right: 50,
                                        top: 50,
                                        bottom: 50,
                                        child: Image.asset(
                                          _filteredPlantList[index].imageURL,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        left: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _filteredPlantList[index]
                                                  .category,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Text(
                                              _filteredPlantList[index]
                                                  .plantName,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        right: 20,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            r'$' +
                                                _filteredPlantList[index].price
                                                    .toString(),
                                            style: TextStyle(
                                              color: Constants.primaryColor,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),

                // Header untuk bagian bawah
                Container(
                  padding: const EdgeInsets.only(left: 16, bottom: 10, top: 20),
                  child: Text(
                    selectedIndex == 0
                        ? 'New Plants'
                        : '${_plantTypes[selectedIndex]} Plants',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BAGIAN BAWAH - SCROLLABLE (juga menggunakan filtered list)
          Expanded(
            child:
                _filteredPlantList.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No plants found in this category',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _filteredPlantList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return PlantWidget(
                          index: index,
                          plantList:
                              _filteredPlantList, // Gunakan filtered list
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
