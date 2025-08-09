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

  bool _isLoading = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  void _updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    _formKey.currentState?.save();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(context, listen: false).save(_formData);

      if (!mounted) return; // evita usar context após dispose
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro ao salvar o produto!'),
          content: Text('Entre em contato com o suporte!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        title: const Text('Cadastro de Produto'),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nome'),
                      initialValue: _formData['name']?.toString(),
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
                      initialValue: _formData['price']?.toString(),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
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
                      initialValue: _formData['description']?.toString(),
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
                            decoration: InputDecoration(
                              labelText: 'Url da Imagem',
                            ),
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
                                  child: Image.network(
                                    _imageUrlController.text,
                                  ),
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
