import 'dart:typed_data';
import '../../../domain/entities/analysis_entities.dart';

class ElfParser {
  static const int ptLoad = 1;
  static const int pageSize16kb = 16384;

  static AlignmentResult check16kbAlignment(List<int> bytes) {
    if (bytes.length < 64) {
      return AlignmentResult(
        isAligned: false,
        message: 'File too small to be an ELF',
      );
    }

    final byteData = ByteData.view(Uint8List.fromList(bytes).buffer);

    if (byteData.getUint8(0) != 0x7F ||
        byteData.getUint8(1) != 0x45 ||
        byteData.getUint8(2) != 0x4C ||
        byteData.getUint8(3) != 0x46) {
      return AlignmentResult(isAligned: false, message: 'Not a valid ELF file');
    }

    int eiClass = byteData.getUint8(4);
    if (eiClass != 2) {
      return AlignmentResult(
        isAligned: true,
        message: 'Not a 64-bit ELF (32-bit implies no strict 16KB enforce)',
      );
    }

    int eiData = byteData.getUint8(5);
    Endian endian = eiData == 2 ? Endian.big : Endian.little;

    int ePhoff = byteData.getUint64(32, endian);
    int ePhentsize = byteData.getUint16(54, endian);
    int ePhnum = byteData.getUint16(56, endian);

    if (bytes.length < ePhoff + (ePhnum * ePhentsize)) {
      return AlignmentResult(isAligned: false, message: 'Truncated ELF file');
    }

    List<String> errors = [];
    bool hasPTLoad = false;

    for (int i = 0; i < ePhnum; i++) {
      int offset = ePhoff + (i * ePhentsize);

      int pType = byteData.getUint32(offset, endian);

      if (pType == ptLoad) {
        hasPTLoad = true;

        int pOffset = byteData.getUint64(offset + 8, endian);
        int pVaddr = byteData.getUint64(offset + 16, endian);
        int pAlign = byteData.getUint64(offset + 48, endian);

        if (pAlign < pageSize16kb) {
          errors.add(
            'PT_LOAD offset 0x${pOffset.toRadixString(16)} has p_align=$pAlign (Expected >= 16384)',
          );
        } else {
          if ((pVaddr % pAlign) != (pOffset % pAlign)) {
            errors.add(
              'PT_LOAD offset 0x${pOffset.toRadixString(16)} fails congruence check',
            );
          }
        }
      }
    }

    if (!hasPTLoad) {
      return AlignmentResult(
        isAligned: false,
        message: 'No PT_LOAD segments found',
      );
    }

    if (errors.isNotEmpty) {
      return AlignmentResult(isAligned: false, message: errors.join('\\n'));
    }

    return AlignmentResult(
      isAligned: true,
      message: '16KB aligned (p_align >= 16384 and congruent)',
    );
  }
}
