import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();

    _imageUrlFocus.addListener(_updateImage);
  }

  @override
  void dispose() {
    super.dispose();

    _imageUrlFocus.removeListener(_updateImage);

    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
  }

  void _updateImage() {
    setState(() {});
  }

  void _submitForm() {
    _formKey.currentState?.save();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: _formData['name'] as String,
      description: _formData['description'] as String,
      price: double.tryParse(_formData['price'] as String) ?? 0.0,
      imageUrl: _formData['imageUrl'] as String,
    );

    Provider.of<ProductList>(context, listen: false).add(newProduct);
    Navigator.of(context).pop();
  }

  bool _isValidImageUrl(String url) {
    bool valid = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    bool endsWithFile =
        url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return valid && endsWithFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (name) {
                  final pivot = name ?? '';

                  if (pivot.trim().isEmpty) {
                    return 'O nome é obrigatório';
                  }

                  if (pivot.trim().length < 3) {
                    return 'O nome precisa de no mínimo 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocus,
                validator: (price) {
                  final pivot = price ?? '';
                  final value = double.tryParse(pivot) ?? -1;

                  if (value <= 0) {
                    return 'Informe um preço válido';
                  }

                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) => _formData['price'] = price ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (description) {
                  final pivot = description ?? '';

                  if (pivot.trim().isEmpty) {
                    return 'A descrição é obrigatória';
                  }

                  if (pivot.trim().length < 10) {
                    return 'A descrição precisa ter no mínimo 10 letras';
                  }

                  return null;
                },
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url da Imagem'),
                      focusNode: _imageUrlFocus,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm(),
                      validator: (imageUrl) {
                        final pivot = imageUrl ?? '';

                        if (!_isValidImageUrl(pivot)) {
                          return 'Informe uma URL válida';
                        }

                        return null;
                      },
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
