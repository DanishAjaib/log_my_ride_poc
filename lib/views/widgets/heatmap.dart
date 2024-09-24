import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HeatmapWidget extends StatelessWidget {
  final List<List<double>> sectorData; // Assuming a 2D array of sector times
  final int bestLapIndex; // Index of the lap with the best sector

  HeatmapWidget({
    required this.sectorData,
    required this.bestLapIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lap vs Sector',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: HeatMap(
              sectorData: sectorData,
              bestLapIndex: bestLapIndex,
            ),
          ),
        ],
      ),
    );
  }
}

class HeatMap extends StatelessWidget {
  final List<List<double>> sectorData;
  final int bestLapIndex;

  HeatMap({
    required this.sectorData,
    required this.bestLapIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Lap labels
        Container(
          height: 380,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children:[
              Transform.rotate(
                angle: -1.5708, // Rotate 90 degrees counterclockwise (in radians)
                child: const Text('LAP 1', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              Transform.rotate(
                angle: -1.5708, // Rotate 90 degrees counterclockwise (in radians)
                child: const Text('LAP 2', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              Transform.rotate(
                angle: -1.5708, // Rotate 90 degrees counterclockwise (in radians)
                child: const Text('LAP 3', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              Transform.rotate(
                angle: -1.5708, // Rotate 90 degrees counterclockwise (in radians)
                child: const Text('LAP 4', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),

            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              // Sector labels
              Row(
                children: List.generate(sectorData[0].length, (index) {
                  return Expanded(
                    child: Container(
                      height: 50, // Adjust height to match grid cell height
                      alignment: Alignment.center,
                      child: Text('SECTOR ${index + 1}', style: const TextStyle(color: Colors.grey, fontSize: 12),),

                    ),
                  );
                }),
              ),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sectorData[0].length, // Sector count on x-axis
                    crossAxisSpacing: 4.0, // Adjust spacing between columns
                    mainAxisSpacing: 4.0,  // Adjust spacing between rows
                    childAspectRatio: 1.0,
                  ),
                  itemCount: sectorData.length * sectorData[0].length,
                  itemBuilder: (context, index) {
                    int row = index ~/ sectorData[0].length; // Lap count (y-axis)
                    int col = index % sectorData[0].length;  // Sector number (x-axis)

                    double sectorTime = sectorData[row][col];
                    bool isBestSector = row == bestLapIndex;

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                        color: isBestSector
                            ? Colors.amber // Gold color for the best sector
                            : Color.lerp(Colors.white, Colors.red, sectorTime / 100),
                      ),
                      margin: const EdgeInsets.all(2),
                      child: Center(
                        child: Text(
                          '${sectorTime.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}