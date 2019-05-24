import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'model/product.dart';

const double _kFlingVelocity = 2.0;

class BackDrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const BackDrop({
    @required this.currentCategory,
    @required this.frontLayer,
    @required this.backLayer,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(currentCategory != null),
        assert(frontLayer != null),
        assert(backLayer != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackDropState createState() => _BackDropState();
}

class _BackDropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  @override
  void didUpdateWidget(BackDrop old) {
    super.didUpdateWidget(old);

    if (widget.currentCategory != old.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _controller.fling(velocity: _kFlingVelocity);
    }
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, layerTop, 0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(_controller.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      brightness: Brightness.light,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: _toggleBackdropLayerVisibility,
      ),
      title: Text('SHRINE'),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            semanticLabel: 'search',
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.tune,
            semanticLabel: 'filter',
          ),
          onPressed: () {},
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(builder: _buildStack),
    );
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({Key key, this.onTap, this.child}) : super(key: key);

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
