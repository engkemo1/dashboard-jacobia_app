import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../../ViewModel/file_handeler.dart';

class PdfInvoiceApi {
  static generate2(
    var question,
    PdfPageFormat? format,
      var category
  ) async {
    final pdf = pw.Document();
    var data = await rootBundle.load("fonts/IBMPlexSansArabic-Bold.ttf");
    final ttf = Font.ttf(data);
    final iconImage =
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();

    final tableHeaders = [
      'الجواب',

      'السؤال',
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        theme: ThemeData.withFont(
          base: ttf,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(
                  pw.MemoryImage(iconImage),
                  height: 72,
                  width: 72,
                ),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Jacobia',
                        style: pw.TextStyle(
                          fontSize: 17.0,
                        ),
                        textAlign: TextAlign.center),
                    pw.Text(category,
                        textDirection: pw.TextDirection.rtl,
                        style: const pw.TextStyle(
                          fontSize: 15.0,
                          color: PdfColors.grey700,
                        ),
                        textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 40),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Table.fromTextArray(
                headers: tableHeaders,
                data: List.generate(
                    question.length,
                    (index) => [

                          question[index]['type'] == 'options'
                              ? question[index]['answer'] == "A"
                                  ? question[index]['option1']
                                  :        question[index]['answer'] == "B"
                                      ?        question[index]['option2']
                                      :        question[index]['answer'] ==
                                              "C"
                                          ?      question[index]['option3']
                                          :        question[index]
                                                      ['answer'] ==
                                                  "D"
                                              ?        question[index]
                                                  ['option4']
                                              :        question[index]
                                                  ['option5']
                              :        question[index]['answer'],

                        question[index]['question'],

                        ]),
                border: null,
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                cellHeight: 30.0,
                headerAlignment: Alignment.center,
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerRight,
                },
              ),
            ),
            pw.Divider(),
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                'Jacobia',
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text("support:03122424"),
                  pw.Text(
                    'Address: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'jacobia@gmail.com',
                  ),
                  pw.Text(
                    'Email: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
