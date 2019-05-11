import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Chocies { Seoul, Busan, Daegu, Single, Double, Family }
enum Size { Single, Double, Family }

void main() => runApp(SearchPage());

class SearchPage extends StatefulWidget {
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;
  List<bool> stars = [false, false, false, false, false];
  int changedIndex = 4;

//  final expanded =  new List<bool>(5);
  List<bool> expanded = [false, false, false];

  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  bool _buttonDisable = false;

  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = true}) {
    return alwaysUse24HourFormat
        ? TimeOfDayFormat.h_colon_mm_space_a
        : TimeOfDayFormat.h_colon_mm_space_a;
  }

  void _onSwitch(bool value) =>
      setState(() => _buttonDisable = !_buttonDisable);

  String _location = "Seoul";
  String _size = "Single";
  String _date1 = "";
  String _time1 = "";
  String _date2 = "";
  String _time2 = "";
  double _cost = 150.0;

  Future<void> _checkOptions() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          backgroundColor: Colors.blueAccent,
          title: Text('Please Check Your Choices!'),
          titlePadding: EdgeInsets.only(
            left: 13,
            top: 14,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.lightBlue[100],
                      size: 20,
                    ),
                    Text(_location),
                    SizedBox(width: 30),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      color: Colors.lightBlue[100],
                      size: 20,
                    ),
                    Text(_size),
                    SizedBox(width: 30),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.attach_money,
                      color: Colors.lightBlue[100],
                      size: 20,
                    ),
                    Text(_cost.toString()),
                    SizedBox(width: 30),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    Column(
                      children: <Widget>[
                        widget.stars[0]
                            ? Row(
                                children: List.generate(
                                    1, (index) => _buildStars(context, index),
                                    growable: false))
                            : Container(),
                        widget.stars[1]
                            ? Row(
                                children: List.generate(
                                    2, (index) => _buildStars(context, index),
                                    growable: false))
                            : Container(),
                        widget.stars[2]
                            ? Row(
                                children: List.generate(
                                    3, (index) => _buildStars(context, index),
                                    growable: false))
                            : Container(),
                        widget.stars[3]
                            ? Row(
                                children: List.generate(
                                    4, (index) => _buildStars(context, index),
                                    growable: false))
                            : Container(),
                        widget.stars[4]
                            ? Row(
                                children: List.generate(
                                    5, (index) => _buildStars(context, index),
                                    growable: false))
                            : Container(),
                      ],
                    ),
                    SizedBox(width: 30),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.help,
                      color: Colors.lightBlue[100],
                      size: 20,
                    ),
                    _buttonDisable
                        ? Text("Dates Not Chosen")
                        : Text("Dates Chosen"),
                    SizedBox(width: 30),
                  ],
                ),
                _buttonDisable
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: Colors.lightBlue[100],
                            size: 20,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("In",
                                      style: TextStyle(
                                        fontSize: 9,
                                      ))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Out",
                                      style: TextStyle(
                                        fontSize: 9,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("${_date1}   ${_time1}",
                                      style: TextStyle(
                                        fontSize: 10,
                                      ))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text("${_date2}   ${_time2}",
                                      style: TextStyle(
                                        fontSize: 10,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            ButtonTheme(
                height: 50,
                minWidth: 120,
                child: RaisedButton(
                  child: Text(
                    "Search",
                    style: TextStyle(fontSize: 20, color: Colors.blue[50]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                )),
            ButtonTheme(
                height: 50,
                minWidth: 120,
                child: RaisedButton(
                  color: Colors.grey,
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 20, color: Colors.grey[50]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                )),
          ],
        );
      },
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2022));
    print(DateFormat.yMMMMEEEEd().format(picked));
    if (picked != null)
      setState(
          () => _date1 = DateFormat.yMMMMEEEEd().format(picked).toString());
  }

  Future _selectDate2() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2022));
    print(DateFormat.yMMMMEEEEd().format(picked));

    if (picked != null)
      setState(
          () => _date2 = DateFormat.yMMMMEEEEd().format(picked).toString());
  }

  Future _selectTime() async {
    int hour;
    TimeOfDay selTime = await showTimePicker(
      initialTime: TimeOfDay(hour: 10, minute: 00),
      context: context,
    );
    print(selTime.hour);
    print(selTime.minute);
    print(selTime.period.toString().substring(10, 12));
    if (selTime.hour > 12) {
      hour = selTime.hour - 12;
    } else {
      hour = selTime.hour;
    }

    if (selTime != null)
      setState(() => _time1 = hour.toString() +
          ":" +
          selTime.minute.toString() +
          " " +
          (selTime.period.toString().substring(10, 12)));
  }

  Future _selectTime2() async {
    int hour;
    TimeOfDay selTime2 = await showTimePicker(
      initialTime: TimeOfDay(hour: 10, minute: 00),
      context: context,
    );
    if (selTime2.hour > 12) {
      hour = selTime2.hour - 12;
    } else {
      hour = selTime2.hour;
    }
    print(hour);
    if (selTime2 != null)
      setState(() => _time2 = hour.toString() +
          ":" +
          selTime2.minute.toString() +
          " " +
          (selTime2.period.toString().substring(10, 12)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('Search'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionPanelList(
            children: <ExpansionPanel>[
              //LOCATION - cities
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) => Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 13, bottom: 20),
                          child: Text(
                            "Location",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 45, bottom: 20),
                          child: Text(
                            "select location",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                body: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        title: const Text('Seoul'),
                        value: "Seoul",
                        groupValue: _location,
                        onChanged: (String value) {
                          setState(() {
                            _location = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Busan'),
                        value: "Busan",
                        groupValue: _location,
                        onChanged: (String value) {
                          setState(() {
                            _location = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Daegu'),
                        value: "Daegu",
                        groupValue: _location,
                        onChanged: (String value) {
                          setState(() {
                            _location = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                isExpanded: widget.expanded[0],
              ),
              //ROOM TYPES
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) => Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 13, bottom: 20),
                          child: Text(
                            "Room",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 75, bottom: 20),
                          child: Text(
                            "select room",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                body: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        title: const Text('Single'),
                        value: "Single",
                        groupValue: _size,
                        onChanged: (String value) {
                          setState(() {
                            _size = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Double'),
                        value: "Double",
                        groupValue: _size,
                        onChanged: (String value) {
                          setState(() {
                            _size = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Family'),
                        value: "Family",
                        groupValue: _size,
                        onChanged: (String value) {
                          setState(() {
                            _size = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                isExpanded: widget.expanded[1],
              ),

              //HOTEL CLASSES
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) => Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 13, bottom: 20),
                          child: Text(
                            "Class",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 55, bottom: 20),
                          child: Text(
                            "select hotel classes",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                body: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: widget.stars[0],
                            onChanged: (bool value) {
                              setState(() {
                                widget.stars[0] = value;
                                print(widget.stars[0]);
                              });
                            },
                          ),
                          Row(
                              children: List.generate(
                                  1, (index) => _buildStar(context, index),
                                  growable: false)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: widget.stars[1],
                            onChanged: (bool value) {
                              setState(() {
                                widget.stars[1] = value;
                                print(widget.stars[1]);
                              });
                            },
                          ),
                          Row(
                              children: List.generate(
                                  2, (index) => _buildStar(context, index),
                                  growable: false)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: widget.stars[2],
                            onChanged: (bool value) {
                              setState(() {
                                widget.stars[2] = value;
                                print(widget.stars[2]);
                              });
                            },
                          ),
                          Row(
                              children: List.generate(
                                  3, (index) => _buildStar(context, index),
                                  growable: false)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: widget.stars[3],
                            onChanged: (bool value) {
                              setState(() {
                                widget.stars[3] = value;
                                print(widget.stars[3]);
                              });
                            },
                          ),
                          Row(
                              children: List.generate(
                                  4, (index) => _buildStar(context, index),
                                  growable: false)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: widget.stars[4],
                            onChanged: (bool value) {
                              setState(() {
                                widget.stars[4] = value;
                                print(widget.stars[4]);
                              });
                            },
                          ),
                          Row(
                              children: List.generate(
                                  5, (index) => _buildStar(context, index),
                                  growable: false)),
                        ],
                      ),
                    ],
                  ),
                ),
                isExpanded: widget.expanded[2],
              ),
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) => Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 13, bottom: 20),
                          child: Text(
                            "Date",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 13.5, left: 90, bottom: 20),
                            child: Text(
                              'No Specific Dates',
                              style: TextStyle(
                                  fontSize: 10,
//                                      fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 13.5, left: 10, bottom: 20),
                          child: Switch(
                            value: _buttonDisable,
                            onChanged: _onSwitch,
                          ),
                        ),
                      ],
                    ),
                body: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(children: <Widget>[
                              SizedBox(height: 30),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.deepOrangeAccent,
                                    size: 20,
                                  ),
                                  Text("check-in"),
                                ],
                              ),
                              Text(_date1),
                              Text(_time1),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.deepOrangeAccent,
                                    size: 20,
                                  ),
                                  Text("check-out"),
                                ],
                              ),
                              Text(_date2),
                              Text(_time2),
                            ]),
                            SizedBox(width: 50),
                            Column(children: <Widget>[
                              RaisedButton(
                                onPressed: _buttonDisable ? null : _selectDate,
                                child: Text('Select Date'),
                              ),
                              RaisedButton(
                                onPressed: _buttonDisable ? null : _selectTime,
                                child: Text('Select Time'),
                              ),
                              RaisedButton(
                                onPressed: _buttonDisable ? null : _selectDate2,
                                child: Text('Select Date'),
                              ),
                              RaisedButton(
                                onPressed: _buttonDisable ? null : _selectTime2,
                                child: Text('Select Time'),
                              )
                            ]),
                          ]),
                    ],
                  ),
                ),
                isExpanded: true,
              ),
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) => Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 13.5, left: 13, bottom: 20, right: 50),
                          child: Text(
                            "Fee",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 13.5, left: 90, bottom: 20),
                            child: Text(
                              "Up To \$ ${_cost}",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )),
                      ],
                    ),
                body: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 40, right: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Slider(
                              activeColor: Colors.indigoAccent,
                              min: 0.0,
                              max: 1000,
                              divisions: 50,
                              onChanged: (newRating) {
                                setState(() => _cost = newRating);
//                                print(_cost);
                              },
                              value: _cost,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 90, top: 20),
                            child: ButtonTheme(
                                height: 50,
                                minWidth: 120,
                                child: RaisedButton(
                                  child: Text(
                                    "Search",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue[50]),
                                  ),
                                  onPressed: (_checkOptions),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0)),
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                isExpanded: true,
              ),
            ],
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                print(index);
                widget.changedIndex = index;
                widget.expanded[index] = !widget.expanded[index];
              });
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildStar(BuildContext context, int index) {
  Icon icon;
//  print(index);
  icon = Icon(
    Icons.star,
    color: Colors.yellow,
    size: 30,
  );
  return icon;
}

Widget _buildStars(BuildContext context, int index) {
  Icon icon;
  icon = Icon(
    Icons.star,
    color: Colors.yellow,
    size: 15,
  );
  return icon;
}
