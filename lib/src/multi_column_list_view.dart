import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class MultiColumnListView extends StatefulWidget {
  MultiColumnListView({
    super.key,
    required this.columnWidths,
    required this.columnTitles,
    this.headerRowHeight = 24,
    this.dataRowHeight = 24,
    this.dividerWidth = 3,
    this.controller,
    required this.rowCellsBuilder,
    this.tappedRowColor,
    this.hoveredRowColor,
    this.headerRowBgColor,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowContextMenu,
  });

  List<Widget> columnTitles;
  List<double> columnWidths;
  double headerRowHeight;
  double dataRowHeight;
  double dividerWidth;

  MultiColumnListController? controller;
  List<Widget> Function(BuildContext context, int rowIndex) rowCellsBuilder;

  Color? tappedRowColor;
  Color? hoveredRowColor;
  Color? headerRowBgColor;

  Function(int)? onRowTap;
  Function(int)? onRowDoubleTap;
  Function(TapDownDetails, int)? onRowContextMenu;

  @override
  State<MultiColumnListView> createState() => _MultiColumnListViewState();
}

class _MultiColumnListViewState extends State<MultiColumnListView> {
  final MultiSplitViewController _headerController = MultiSplitViewController();
  List<double> columnWidths = [];
  List<Widget> columnTitles = [];

  int _lastClickMilliseconds = -1;
  int _lastTappedRowIdx = -1;

  int _hoveredRowIdx = -1;
  int _selectedRowIdx = -1;

  MultiColumnListController _controller = MultiColumnListController();

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    }

    columnWidths = widget.columnWidths;
    columnTitles = widget.columnTitles;

    _headerController.areas =
        List<Area>.generate(columnTitles.length, (int idx) {
      return Area(
          data: widget.columnTitles[idx],
          min: 30,
          size: columnWidths.isNotEmpty
              ? columnWidths[idx]
              : widget.columnWidths[idx]);
    });
  }

  @override
  Widget build(BuildContext context) {
    MultiSplitView headerView = MultiSplitView(
        onDividerDragUpdate: onHeaderDividerDragUpdate,
        onDividerTap: (_) => {},
        onDividerDoubleTap: (_) => {},
        controller: _headerController,
        pushDividers: true,
        builder: (BuildContext context, Area area) => area.data as Widget);

    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: widget.headerRowBgColor,
        ),
        height: widget.headerRowHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Container(
                    height: 20,
                    child: MultiSplitViewTheme(
                        data: MultiSplitViewThemeData(
                          dividerThickness: widget.dividerWidth,
                        ),
                        child: headerView)))
          ],
        ),
      ),
      Expanded(
          child: ListenableBuilder(
        listenable: Listenable.merge([_controller.rows]),
        builder: (BuildContext context, Widget? child) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int idx) {
              List<Widget> rowCells = widget.rowCellsBuilder(context, idx);
              return GestureDetector(
                  onSecondaryTapDown: (details) {
                    if (widget.onRowContextMenu != null) {
                      widget.onRowContextMenu!(details, idx);
                    }
                  },
                  onTapDown: (_) {
                    int currMills = DateTime.now().millisecondsSinceEpoch;
                    if ((currMills - _lastClickMilliseconds) < 500) {
                      if (idx == _lastTappedRowIdx) {
                        if (widget.onRowDoubleTap != null) {
                          widget.onRowDoubleTap!(idx);
                        }
                      }
                    } else {
                      _lastClickMilliseconds = currMills;
                      _lastTappedRowIdx = idx;
                      onRowTap(idx);
                    }
                  },
                  child: MouseRegion(
                      onHover: (_) {
                        setState(() {
                          _hoveredRowIdx = idx;
                        });
                      },
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: _hoveredRowIdx == idx
                                ? widget.hoveredRowColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedRowIdx == idx
                                  ? widget.tappedRowColor
                                  : Colors.transparent,
                            ),
                            child: Container(
                              height: widget.dataRowHeight,
                              // child: widget.rowCellsBuilder(context, idx),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List<Widget>.generate(
                                      rowCells.length, (int colIdx) {
                                    return Container(
                                      width: columnWidths[colIdx]+widget.dividerWidth,
                                      child: rowCells[colIdx],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )));
            },
            itemCount: _controller.rows.value.length,
          );
        },
      )),
    ]);
  }

  onRowDoubleTap(int idx) {
    if (widget.onRowDoubleTap != null) {
      widget.onRowDoubleTap!(idx);
    }
  }

  onRowTap(int idx) {
    setState(() {
      _selectedRowIdx = idx;
    });
    if (widget.onRowTap != null) {
      widget.onRowTap!(idx);
    }
  }

  onHeaderDividerDragUpdate(int idx) {
    setState(() {
      columnWidths = List<double>.generate(_headerController.areas.length,
          (int idx) => _headerController.areas[idx].size!);
    });
  }
}

class MultiColumnListController {
  ValueNotifier<List<dynamic>> rows = ValueNotifier([]);
}
