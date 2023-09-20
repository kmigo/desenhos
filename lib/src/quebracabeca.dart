// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class QuebraCabeca extends StatefulWidget {
  const QuebraCabeca({super.key});

  @override
  State<QuebraCabeca> createState() => _QuebraCabecaState();
}

class _QuebraCabecaState extends State<QuebraCabeca> {
  final linhas = 3;
  final colunas = 3;

  final largura = 50.0;
  final altura = 50.0;
  PecaRegra? pecaVazia;
  List<Widget> childreen = [];
  List<List<int>> posicoes = [];
  criarBoard() {
    childreen = [];
    
    List<PecaRegra> pecas = [];
    int count = 0;
    for (int linha = 0; linha < linhas; linha++) {
      posicoes.add([]);
      for (int coluna = 0; coluna < colunas; coluna++) {
        posicoes[linha].add(count);
        final peca = PecaRegra(
            index: count,
            largura: largura,
            altura: altura,
            linha: linha,
            coluna: coluna);
        pecas.add(peca);
        count = count + 1;
      }
    }

    shuffleMatrix(posicoes,100);

    final indexs = [...posicoes.expand((element) => element)];

    for(int i = 0; i < indexs.length; i++) {
      final index = indexs[i];

      pecas[i] = pecas[i].copyWith(index: index);
      //posicoes[pecas[i].coluna][pecas[i].linha] = index;
    }
  print(indexs);
      childreen = [
      ...pecas.map<Widget>((e) => 
      PecaWidget(
          regraInicial: e,
          obterPecaVazia: () => pecaVazia!,
          atualizaPecaVazia: (peca) {

              posicoes[peca.coluna][peca.linha] = 0;
              posicoes[pecaVazia!.coluna][pecaVazia!.linha] = peca.index;
              if(isMatrixInOrder(posicoes, linhas, colunas)){
                showDialog(context: context, builder: (ctx){
                  return AlertDialog(
                    title: Text('Parabens'),
                    content: Text('Voce ganhou'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                        criarBoard();
                        setState(() {
                          
                        });
                      }, child: Text('Jogar novamente'))
                    ],
                  );
                });
              }

            pecaVazia = peca;

           print("\ncoluna vertical:\n${posicoes.join('\n coluna vertical:\n')}");
          },
        )).toList()
      
    ];
  final indexVazio = pecas.indexWhere((element) => element.index == 0);
  pecaVazia = pecas[indexVazio];
  childreen[indexVazio] = Positioned(child: Container(),);
print("\ncoluna vertical:\n${posicoes.join('\n coluna vertical:\n')}");

  }


 void shuffleMatrix(List<List<int>> matrix, [int moves = 1000]) {
  int emptyRow = 2;
  int emptyCol = 2;
  Random random = Random();

  for (int i = 0; i < moves; i++) {
    List<List<int>> validMoves = [];
    
    if (emptyRow > 0) validMoves.add([emptyRow - 1, emptyCol]);
    if (emptyRow < 2) validMoves.add([emptyRow + 1, emptyCol]);
    if (emptyCol > 0) validMoves.add([emptyRow, emptyCol - 1]);
    if (emptyCol < 2) validMoves.add([emptyRow, emptyCol + 1]);

    List<int> chosenMove = validMoves[random.nextInt(validMoves.length)];

    // Troque o espaço vazio com o número escolhido
    int temp = matrix[emptyRow][emptyCol];
    matrix[emptyRow][emptyCol] = matrix[chosenMove[0]][chosenMove[1]];
    matrix[chosenMove[0]][chosenMove[1]] = temp;

    // Atualize a posição do espaço vazio
    emptyRow = chosenMove[0];
    emptyCol = chosenMove[1];
  }
}

  @override
  void initState() {
    super.initState();
    criarBoard();
  }

bool isMatrixInOrder(List<List<int>> matrix, int numRows, int numCols) {
  if (matrix.isEmpty || matrix[0].isEmpty) return false;

  int zeroEquivalent = numRows * numCols;

  for (int i = 0; i < numRows; i++) {
    for (int j = 0; j < numCols; j++) {
      // Substitui o valor zero pelo seu equivalente para comparação
      int currentValue = matrix[i][j] == 0 ? zeroEquivalent : matrix[i][j];

      // Verifica se não é o último elemento da última linha
      if (i == numRows - 1 && j == numCols - 1) continue;

      // Obtenha o próximo elemento
      int nextI = j == numCols - 1 ? i + 1 : i;
      int nextJ = j == numCols - 1 ? 0 : j + 1;

      // Substitui o valor zero pelo seu equivalente para comparação
      int nextValue = matrix[nextI][nextJ] == 0 ? zeroEquivalent : matrix[nextI][nextJ];

      // Compare o elemento atual com o próximo
      if (currentValue > nextValue) {
        return false;
      }
    }
  }
  return true;
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: childreen,
      )),
    );
  }
}

class PecaRegra {
  final double largura;
  final double altura;
  final int linha;
  final int coluna;
  final int index;
  const PecaRegra({
    required this.largura,
    required this.altura,
    required this.linha,
    required this.coluna,
    required this.index,
  });

  PecaRegra copyWith(
      {double? largura, double? altura, int? linha, int? coluna, int? index}) {
    return PecaRegra(
      largura: largura ?? this.largura,
      index: index ?? this.index,
      altura: altura ?? this.altura,
      linha: linha ?? this.linha,
      coluna: coluna ?? this.coluna,
    );
  }
}

class PecaWidget extends StatefulWidget {
  final PecaRegra regraInicial;
  final PecaRegra Function() obterPecaVazia;
  final Function(PecaRegra) atualizaPecaVazia;

  const PecaWidget(
      {super.key,
      required this.regraInicial,
      required this.obterPecaVazia,
      required this.atualizaPecaVazia});

  @override
  State<PecaWidget> createState() => _PecaWidgetState();
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '${regraInicial.index}';
  }
}

class _PecaWidgetState extends State<PecaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  PecaRegra? regraAtual;
  PecaRegra? novaRegra;

  @override
  void initState() {
    super.initState();
    regraAtual = widget.regraInicial;
    novaRegra = regraAtual;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, animation) {
          final left = (regraAtual!.linha * regraAtual!.largura);
          final top = (regraAtual!.altura * regraAtual!.coluna);
          final novoLeft = (novaRegra!.linha * novaRegra!.largura);
          final novoTop = (novaRegra!.altura * novaRegra!.coluna);

          return Positioned(
              left: left + ((novoLeft - left) * _animationController.value),
              top: top + ((novoTop - top) * _animationController.value),
              child: InkWell(
                onTap: () {
                  if(_animationController.isAnimating) return;
                  _animationController.reset();
                  novaRegra = widget
                      .obterPecaVazia()
                      .copyWith(index: regraAtual!.index);
                  final novaLinha = novaRegra!.linha - regraAtual!.linha;
                  final novaColuna = novaRegra!.coluna - regraAtual!.coluna;
                  if ([1, -1].contains(novaColuna + novaLinha) &&
                      [0, 1, -1].contains(novaColuna) &&
                      [0, 1, -1].contains(novaLinha)) {
                    widget.atualizaPecaVazia(regraAtual!);

                    _animationController
                        .forward()
                        .whenComplete(() => regraAtual = novaRegra);
                  }
                },
                child: Container(
                    width: regraAtual!.largura,
                    height: regraAtual!.altura,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Text(
                      regraAtual!.index.toString(),
                    )),
              ));
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
