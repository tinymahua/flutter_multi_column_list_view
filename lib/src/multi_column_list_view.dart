/// Multiple column list view like a table.
///
/// Copyright (c) 2025, Tiny.Twist tiny.mahua@gmail.com
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keframe/keframe.dart';
import 'package:multi_split_view/multi_split_view.dart';


class MultiColumnListView extends StatefulWidget {
  const MultiColumnListView({
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
    this.onListContextMenu,
    this.optimizeListRender = false,
    this.debug = false,
  });

  final List<Widget> columnTitles;
  final List<double> columnWidths;
  final double headerRowHeight;
  final double dataRowHeight;
  final double dividerWidth;

  final MultiColumnListController? controller;
  final List<Widget> Function(BuildContext context, int rowIndex)
      rowCellsBuilder;

  final Color? tappedRowColor;
  final Color? hoveredRowColor;
  final Color? headerRowBgColor;

  final Function(int)? onRowTap;
  final Function(int)? onRowDoubleTap;
  final Function(TapDownDetails, int)? onRowContextMenu;
  final Function(TapDownDetails)? onListContextMenu;

  final bool optimizeListRender;

  final bool debug;

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

  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _dataKey = GlobalKey();
  double _blankHeight = 0;

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

    setupEvents();
  }

  setupEvents() {

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 100), dynamicLayoutBlank);
  }

  dynamicLayoutBlank(){
    Timer _ = Timer.periodic(const Duration(milliseconds: 300), (t) {
      if (_dynamicBlankHeight != null) {
        setState(() {
          _blankHeight = _dynamicBlankHeight! < 0 ? 0 : _dynamicBlankHeight!;
        });
        // t.cancel();
      }
    });
  }

  double? get _dynamicBlankHeight {
    double? blankH;
    if (mounted) {
      double? containerH;
      double? headerH;
      double? dataH;
      try {
        var containerCtx = _containerKey.currentContext;
        if (containerCtx != null && containerCtx.mounted && containerCtx.size != null) {
          containerH = containerCtx.size!.height;
        }
        var headerCtx = _headerKey.currentContext;
        if (headerCtx != null && headerCtx.mounted && headerCtx.size != null) {
          headerH = headerCtx.size!.height;
        }
        var dataCtx = _dataKey.currentContext;
        if (dataCtx != null && dataCtx.mounted && dataCtx.size != null) {
          dataH = widget.dataRowHeight * _controller.rows.value.length;
        }
        if (containerH != null && headerH != null && dataH != null) {
          blankH = containerH - headerH - dataH;
        }
      }catch(e){
        /// Do nothing.
      }

    }
    return blankH;
  }

  Widget _buildRow(BuildContext context, int rowIndex) {
    List<Widget> rowCells = widget.rowCellsBuilder(context, rowIndex);
    List<Widget> rowChildren =
        List<Widget>.generate(rowCells.length, (int idx) {
      Widget cellContent = GestureDetector(
        onSecondaryTapDown: (details) {
          setState(() {
            _selectedRowIdx = rowIndex;
          });
          if (widget.onRowContextMenu != null) {
            widget.onRowContextMenu!(details, rowIndex);
          }
        },
        child: rowCells[idx],
      );
      Widget spaceContent = GestureDetector(
        onSecondaryTapDown: rowIndex == _selectedRowIdx ? (details) {
          setState(() {
            _selectedRowIdx = rowIndex;
          });
          if (widget.onRowContextMenu != null) {
            widget.onRowContextMenu!(details, rowIndex);
          }
        }: (details) {
          if (widget.onListContextMenu != null) {
            widget.onListContextMenu!(details);
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            "                                                                                                                          ",
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ),
      );
      Widget cellRow = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: cellContent),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: spaceContent,
            )
          ],
        ),
      );
      return idx == rowCells.length - 1
          ? cellRow
          : SizedBox(
              width: columnWidths[idx] + widget.dividerWidth, child: cellRow);
    });

    return Row(
      children: rowChildren,
    );
  }

  Widget _buildTable(){
    return widget.optimizeListRender ? SizeCacheWidget(
      child: ListView.builder(
        cacheExtent: 50,
        itemBuilder: (BuildContext context, int idx) {
          return FrameSeparateWidget(
            child: GestureDetector(
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
                          child: SizedBox(
                            height: widget.dataRowHeight,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: _buildRow(context, idx)),
                          ),
                        ),
                      ),
                    ))),
          );
        },
        itemCount: _controller.rows.value.length,
      ),
    ): ListView.builder(
        itemBuilder: (BuildContext context, int idx) {
          return GestureDetector(
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
                          child: SizedBox(
                            height: widget.dataRowHeight,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: _buildRow(context, idx)),
                          ),
                        ),
                      ),
                    )),
          );
        },
        itemCount: _controller.rows.value.length,
      );
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

    return Column(key: _containerKey, children: [
      Container(
        key: _headerKey,
        decoration: BoxDecoration(
          color: widget.headerRowBgColor,
        ),
        height: widget.headerRowHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: SizedBox(
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
          key: _dataKey,
          child: ListenableBuilder(
            listenable: Listenable.merge([_controller.rows]),
            builder: (BuildContext context, Widget? child) {
              return _buildTable();
              // return SizeCacheWidget(
              //   child: ListView.builder(
              //     cacheExtent: 50,
              //     itemBuilder: (BuildContext context, int idx) {
              //       return FrameSeparateWidget(
              //         child: GestureDetector(
              //             onTapDown: (_) {
              //               int currMills = DateTime.now().millisecondsSinceEpoch;
              //               if ((currMills - _lastClickMilliseconds) < 500) {
              //                 if (idx == _lastTappedRowIdx) {
              //                   if (widget.onRowDoubleTap != null) {
              //                     widget.onRowDoubleTap!(idx);
              //                   }
              //                 }
              //               } else {
              //                 _lastClickMilliseconds = currMills;
              //                 _lastTappedRowIdx = idx;
              //                 onRowTap(idx);
              //               }
              //             },
              //             child: MouseRegion(
              //                 onHover: (_) {
              //                   setState(() {
              //                     _hoveredRowIdx = idx;
              //                   });
              //                 },
              //                 child: GestureDetector(
              //                   child: Container(
              //                     decoration: BoxDecoration(
              //                       color: _hoveredRowIdx == idx
              //                           ? widget.hoveredRowColor
              //                           : Colors.transparent,
              //                       borderRadius: BorderRadius.circular(4),
              //                     ),
              //                     child: Container(
              //                       decoration: BoxDecoration(
              //                         color: _selectedRowIdx == idx
              //                             ? widget.tappedRowColor
              //                             : Colors.transparent,
              //                       ),
              //                       child: SizedBox(
              //                         height: widget.dataRowHeight,
              //                         child: SingleChildScrollView(
              //                             scrollDirection: Axis.horizontal,
              //                             child: _buildRow(context, idx)),
              //                       ),
              //                     ),
              //                   ),
              //                 ))),
              //       );
              //     },
              //     itemCount: _controller.rows.value.length,
              //   ),
              // );
            },
          )),
      GestureDetector(
          onSecondaryTapDown: (details) {
            if (widget.onListContextMenu != null) {
              widget.onListContextMenu!(details);
            }
          },
          child: Container(
            height: _blankHeight,
            color: Colors.transparent,
            child: const Row(children: [Expanded(child: Text(" "))]),
          ),
        )
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

class MultiColumnListController{
  ValueNotifier<List<dynamic>> rows = ValueNotifier([]);
}
