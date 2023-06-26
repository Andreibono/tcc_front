import 'package:flutter/material.dart';

class DeleteModal extends StatelessWidget {
  final String type;
  var project;
  var company;
  DeleteModal({Key? key, required this.type, this.project, this.company})
      : super(key: key);

  @override
  void submit() {}

  Widget build(BuildContext context) {
    void close() {
      Navigator.of(context).pop();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          type == "project"
              ? Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    "Tem Certeza que deseja deletar o Projeto?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    "Tem Certeza que Deseja Deletar a Empresa?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: submit,
                child: const Text(
                  'Sim',
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 8)),
              ),
              ElevatedButton(
                onPressed: close,
                child: const Text(
                  'Não',
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 8)),
              )
            ],
          )
        ],
      ),
    );
  }
}
