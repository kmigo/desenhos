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
  List<AnimationController> controls = [];
  List<List<int>> posicoes = [];
  bool reiniciar = true;
  criarBoard({bool fallbalck = false}) {
    for (var element in controls) {
      element.dispose();
    }
    pecaVazia=null;
    childreen = [];
    controls = [];
    posicoes = [];
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

    posicoes = shuffleSlidingPuzzle(linhas, colunas);
    if (fallbalck) {
      posicoes = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0]
      ];
    }

    final indexs = [...posicoes.expand((element) => element)];

    for (int i = 0; i < indexs.length; i++) {
      final index = indexs[i];

      pecas[i] = pecas[i].copyWith(index: index);
      posicoes[pecas[i].linha][pecas[i].coluna] = index;
    }

    childreen = [
      ...pecas
          .map<Widget>((e) => PecaWidget(
                regraInicial: e,
                obterPecaVazia: () => pecaVazia!,
                animationController: (vsync) {
                  final control = AnimationController(
                    duration: const Duration(milliseconds: 400),
                    vsync: vsync,
                  );
                  return control;
                },
                atualizaPecaVazia: (peca) {
                  posicoes[peca.linha][peca.coluna] = 0;
                  posicoes[pecaVazia!.linha][pecaVazia!.coluna] = peca.index;
                  pecaVazia = peca;
                  final win = isMatrixInOrder(posicoes, linhas, colunas);
                  if (win) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text('Parabens'),
                            content: Text('Voce ganhou'),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    criarBoard();

                                    for (var control in controls) {
                                      control.forward();
                                    }
                                    setState(() {
                                      reiniciar = true;
                                    });
                                  },
                                  child: Text('Jogar novamente'))
                            ],
                          );
                        });
                  }

                  

                
                },
              ))
          .toList()
    ];
    final indexVazio = pecas.indexWhere((element) => element.index == 0);
    pecaVazia = pecas[indexVazio];
    childreen[indexVazio] = Positioned(
      child: Container(),
    );
    print("\ncoluna vertical:\n${posicoes.join('\n coluna vertical:\n')}");
  }

  List<List<int>> shuffleSlidingPuzzle(int rows, int cols) {
    List<List<int>> matrix = List.generate(
        rows, (i) => List.generate(cols, (j) => i * cols + j + 1));
    matrix[rows - 1][cols - 1] = 0;
    int emptyRow = rows - 1;
    int emptyCol = cols - 1;
    int moves = max(100,
        rows * cols * 10); // número de movimentos aleatórios para embaralhar
    Random random = Random();

    void swap(int x1, int y1, int x2, int y2) {
      int temp = matrix[x1][y1];
      matrix[x1][y1] = matrix[x2][y2];
      matrix[x2][y2] = temp;
    }

    for (int i = 0; i < moves; i++) {
      List<int> moveOptions = [0, 1, 2, 3]; // 0:UP, 1:DOWN, 2:LEFT, 3:RIGHT
      while (moveOptions.isNotEmpty) {
        int move = moveOptions.removeAt(random.nextInt(moveOptions.length));
        bool moved = false;

        switch (move) {
          case 0: // UP
            if (emptyRow > 0) {
              swap(emptyRow, emptyCol, emptyRow - 1, emptyCol);
              emptyRow--;
              moved = true;
            }
            break;
          case 1: // DOWN
            if (emptyRow < rows - 1) {
              swap(emptyRow, emptyCol, emptyRow + 1, emptyCol);
              emptyRow++;
              moved = true;
            }
            break;
          case 2: // LEFT
            if (emptyCol > 0) {
              swap(emptyRow, emptyCol, emptyRow, emptyCol - 1);
              emptyCol--;
              moved = true;
            }
            break;
          case 3: // RIGHT
            if (emptyCol < cols - 1) {
              swap(emptyRow, emptyCol, emptyRow, emptyCol + 1);
              emptyCol++;
              moved = true;
            }
            break;
        }
        if (moved)
          break; // se um movimento válido foi feito, saia do loop e continue com o próximo movimento
      }
    }
    return matrix;
  }

  @override
  void initState() {
    super.initState();
    criarBoard(fallbalck: true);
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
        int nextValue =
            matrix[nextI][nextJ] == 0 ? zeroEquivalent : matrix[nextI][nextJ];

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
          child: reiniciar ? Center(
            child:   ElevatedButton(onPressed: (){
              setState(() {
                reiniciar = false;
              });
            }, child: Text('Iniciar')),
          ): Stack(
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
  final AnimationController Function(TickerProvider) animationController;
  const PecaWidget(
      {super.key,
      required this.regraInicial,
      required this.obterPecaVazia,
      required this.animationController,
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
    _animationController = widget.animationController(this);

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
          final left = (regraAtual!.coluna * regraAtual!.largura);
          final top = (regraAtual!.altura * regraAtual!.linha);
          final novoLeft = (novaRegra!.coluna * novaRegra!.largura);
          final novoTop = (novaRegra!.altura * novaRegra!.linha);

          return Positioned(
              left: left + ((novoLeft - left) * _animationController.value),
              top: top + ((novoTop - top) * _animationController.value),
              child: InkWell(
                onTap: () {
                  if (_animationController.isAnimating) return;
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
