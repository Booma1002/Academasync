import 'package:equatable/equatable.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Roadmap Progress Model.                       |
\*----------------------------------------------*/
class RoadmapData extends Equatable {
  final String? startDate;
  /*----------------------------------------------*\
  |  Hold strings as 'm1-d1'                       |
  \*----------------------------------------------*/
  final List<String> burnedTokens;

  const RoadmapData({this.startDate, this.burnedTokens = const []});

  factory RoadmapData.fromJson(Map<String, dynamic> json) {
    return RoadmapData(
      startDate: json['startDate'],
      burnedTokens: List<String>.from(json['burnedTokens'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'burnedTokens': burnedTokens,
    };
  }

  @override
  List<Object?> get props => [startDate, burnedTokens];
}
