import '/flutter_flow/flutter_flow_util.dart';
import 'continious_vision_widget.dart' show ContiniousVisionWidget;
import 'package:flutter/material.dart';

class ContiniousVisionModel extends FlutterFlowModel<ContiniousVisionWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
