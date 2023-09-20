// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

class QuebraCabeca extends StatefulWidget {
  const QuebraCabeca({super.key});

  @override
  State<QuebraCabeca> createState() => _QuebraCabecaState();
}

class _QuebraCabecaState extends State<QuebraCabeca> {
  final linhas = 4;
  final colunas = 4;

  final largura = 50.0;
  final altura = 50.0;
  PecaRegra? pecaVazia;
  List<Widget> childreen = [];

  criarBoard() {
    childreen = [];
    int numeroAleatorio = Random().nextInt(colunas * linhas - 1);
    int count = 0;
    for (int linha = 0; linha < linhas; linha++) {
      for (int coluna = 0; coluna < colunas; coluna++) {
        if (count == numeroAleatorio) {
          pecaVazia = PecaRegra(
              largura: largura, altura: altura, linha: linha, coluna: coluna);
          childreen.add(Positioned(child: Container()));
        } else {
          childreen.add(PecaWidget(
              atualizaPecaVazia: (peca) {
                pecaVazia = peca;
              },
              obterPecaVazia: () {
                return pecaVazia!;
              },
              regraInicial: PecaRegra(
                  largura: largura,
                  altura: altura,
                  linha: linha,
                  coluna: coluna)));
        }

        count = count + 1;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    criarBoard();
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
  const PecaRegra({
    required this.largura,
    required this.altura,
    required this.linha,
    required this.coluna,
  });

  PecaRegra copyWith({
    double? largura,
    double? altura,
    int? linha,
    int? coluna,
  }) {
    return PecaRegra(
      largura: largura ?? this.largura,
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
                
                  _animationController.reset();
                  novaRegra = widget.obterPecaVazia();
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
                      ((regraAtual!.linha * regraAtual!.coluna).toString()),
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
