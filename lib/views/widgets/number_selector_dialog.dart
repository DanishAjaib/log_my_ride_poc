import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class NumberSelectorDialog extends StatefulWidget {
  String title;
  Function onNumberSelected;
  int initialValue;
  NumberSelectorDialog({super.key, required this.title, required this.onNumberSelected, required int this.initialValue});

  @override
  State<NumberSelectorDialog> createState() => _NumberSelectorDialogState();
}

class _NumberSelectorDialogState extends State<NumberSelectorDialog> {

  var currentNumber =  0;
  late TextEditingController _controller;


  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue.toString())..addListener(() {
      if(_controller.text.isNotEmpty){
        setState(() {
          currentNumber = int.parse(_controller.text);
        });
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return AlertDialog(
        title: Text(widget.title),
        content: SizedBox(
          height: 200,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              SizedBox(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          // decrement the number
                          if(currentNumber > 0){
                            currentNumber--;
                          }
                        });
                      },
                    ),*/
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        controller: _controller,
                      ),
                    ),
                    /*IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          // increment the number
                           currentNumber += 15;
                        });
                      },
                    ),*/
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Text('mins'),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () {
                    widget.onNumberSelected(currentNumber);
                    Navigator.pop(context);
                  },
                  child: const Text('Select', style: TextStyle(color: Colors.white),),
                ),
              ),

            ],
          ),
        ),
    );
  }
}
