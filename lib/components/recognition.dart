import 'dart:ui';

class Recognition {
  Rect location;
  List<double> embeddings;
  double distance;

  Recognition(this.location, this.embeddings, this.distance);
}
