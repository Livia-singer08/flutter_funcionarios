import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/root/pallet.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List funcionarios = [];
  int indice = 0;

  @override
  void initState() {
    super.initState();
    _carregarJSON();
  }

  Future<void> _carregarJSON() async {
    final dados = await rootBundle.loadString('assets/mockup/funcionario.json');
    setState(() {
      funcionarios = json.decode(dados);
    });
  }

  String _formatarData(String data) {
    final p = data.split('-');
    return '${p[2]}/${p[1]}/${p[0]}';
  }

  String _formatarSalario(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final f = funcionarios.isNotEmpty ? funcionarios[indice] : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Funcionários")),
      backgroundColor: AppColors.neutro1,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// DROPDOWN
            DropdownButton<dynamic>(
              isExpanded: true,
              value: f,
              hint: const Text("Selecione um funcionário"),
              items: funcionarios
                  .map(
                    (func) => DropdownMenuItem(
                      value: func,
                      child: Text(func['nome']),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  indice = funcionarios.indexOf(value);
                });
              },
            ),

            const SizedBox(height: 24),

            /// CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.p2,
                      child: Image.network(
                        f?['avatar'],
                        width: 200,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object exception,
                              StackTrace? stackTrace,
                            ) => Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.textoClaro,
                            ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      f?['nome'] ?? 'Nome',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      f?['cargo'] ?? 'Cargo',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const Divider(height: 32),

                    _info(
                      "Salário",
                      f != null
                          ? _formatarSalario((f['salario'] as num).toDouble())
                          : 'R\$ 0,00',
                    ),

                    _info(
                      "Contratado",
                      f != null
                          ? _formatarData(f['dataContratacao'])
                          : '--/--/----',
                    ),

                    _info("ID", f != null ? '#${f['id']}' : '---'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            /// NAVEGAÇÃO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: indice > 0 ? () => setState(() => indice--) : null,
                  child: const Text("Anterior"),
                ),

                Text(
                  '${funcionarios.isEmpty ? 0 : indice + 1} / ${funcionarios.length}',
                ),

                ElevatedButton(
                  onPressed: indice < funcionarios.length - 1
                      ? () => setState(() => indice++)
                      : null,
                  child: const Text("Próximo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}