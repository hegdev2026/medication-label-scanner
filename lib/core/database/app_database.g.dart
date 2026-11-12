// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicinesTableTable extends MedicinesTable
    with TableInfo<$MedicinesTableTable, MedicinesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicineNameMeta = const VerificationMeta(
    'medicineName',
  );
  @override
  late final GeneratedColumn<String> medicineName = GeneratedColumn<String>(
    'medicine_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genericNameMeta = const VerificationMeta(
    'genericName',
  );
  @override
  late final GeneratedColumn<String> genericName = GeneratedColumn<String>(
    'generic_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
    'strength',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dosageFormMeta = const VerificationMeta(
    'dosageForm',
  );
  @override
  late final GeneratedColumn<String> dosageForm = GeneratedColumn<String>(
    'dosage_form',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batchNumberMeta = const VerificationMeta(
    'batchNumber',
  );
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
    'batch_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufacturingDateMeta = const VerificationMeta(
    'manufacturingDate',
  );
  @override
  late final GeneratedColumn<DateTime> manufacturingDate =
      GeneratedColumn<DateTime>(
        'manufacturing_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _originalManufacturingTextMeta =
      const VerificationMeta('originalManufacturingText');
  @override
  late final GeneratedColumn<String> originalManufacturingText =
      GeneratedColumn<String>(
        'original_manufacturing_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalExpiryTextMeta =
      const VerificationMeta('originalExpiryText');
  @override
  late final GeneratedColumn<String> originalExpiryText =
      GeneratedColumn<String>(
        'original_expiry_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawOcrTextMeta = const VerificationMeta(
    'rawOcrText',
  );
  @override
  late final GeneratedColumn<String> rawOcrText = GeneratedColumn<String>(
    'raw_ocr_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('confirmed'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicineName,
    genericName,
    strength,
    dosageForm,
    batchNumber,
    manufacturer,
    manufacturingDate,
    originalManufacturingText,
    expiryDate,
    originalExpiryText,
    imagePath,
    rawOcrText,
    reviewStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicinesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_name')) {
      context.handle(
        _medicineNameMeta,
        medicineName.isAcceptableOrUnknown(
          data['medicine_name']!,
          _medicineNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicineNameMeta);
    }
    if (data.containsKey('generic_name')) {
      context.handle(
        _genericNameMeta,
        genericName.isAcceptableOrUnknown(
          data['generic_name']!,
          _genericNameMeta,
        ),
      );
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('dosage_form')) {
      context.handle(
        _dosageFormMeta,
        dosageForm.isAcceptableOrUnknown(data['dosage_form']!, _dosageFormMeta),
      );
    }
    if (data.containsKey('batch_number')) {
      context.handle(
        _batchNumberMeta,
        batchNumber.isAcceptableOrUnknown(
          data['batch_number']!,
          _batchNumberMeta,
        ),
      );
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('manufacturing_date')) {
      context.handle(
        _manufacturingDateMeta,
        manufacturingDate.isAcceptableOrUnknown(
          data['manufacturing_date']!,
          _manufacturingDateMeta,
        ),
      );
    }
    if (data.containsKey('original_manufacturing_text')) {
      context.handle(
        _originalManufacturingTextMeta,
        originalManufacturingText.isAcceptableOrUnknown(
          data['original_manufacturing_text']!,
          _originalManufacturingTextMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('original_expiry_text')) {
      context.handle(
        _originalExpiryTextMeta,
        originalExpiryText.isAcceptableOrUnknown(
          data['original_expiry_text']!,
          _originalExpiryTextMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('raw_ocr_text')) {
      context.handle(
        _rawOcrTextMeta,
        rawOcrText.isAcceptableOrUnknown(
          data['raw_ocr_text']!,
          _rawOcrTextMeta,
        ),
      );
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicinesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicinesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicineName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_name'],
      )!,
      genericName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generic_name'],
      ),
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength'],
      ),
      dosageForm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage_form'],
      ),
      batchNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_number'],
      ),
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      ),
      manufacturingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}manufacturing_date'],
      ),
      originalManufacturingText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_manufacturing_text'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      originalExpiryText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_expiry_text'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      rawOcrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_ocr_text'],
      )!,
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MedicinesTableTable createAlias(String alias) {
    return $MedicinesTableTable(attachedDatabase, alias);
  }
}

class MedicinesTableData extends DataClass
    implements Insertable<MedicinesTableData> {
  final int id;
  final String medicineName;
  final String? genericName;
  final String? strength;
  final String? dosageForm;
  final String? batchNumber;
  final String? manufacturer;
  final DateTime? manufacturingDate;
  final String? originalManufacturingText;
  final DateTime? expiryDate;
  final String? originalExpiryText;
  final String? imagePath;
  final String rawOcrText;
  final String reviewStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicinesTableData({
    required this.id,
    required this.medicineName,
    this.genericName,
    this.strength,
    this.dosageForm,
    this.batchNumber,
    this.manufacturer,
    this.manufacturingDate,
    this.originalManufacturingText,
    this.expiryDate,
    this.originalExpiryText,
    this.imagePath,
    required this.rawOcrText,
    required this.reviewStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_name'] = Variable<String>(medicineName);
    if (!nullToAbsent || genericName != null) {
      map['generic_name'] = Variable<String>(genericName);
    }
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    if (!nullToAbsent || dosageForm != null) {
      map['dosage_form'] = Variable<String>(dosageForm);
    }
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || manufacturingDate != null) {
      map['manufacturing_date'] = Variable<DateTime>(manufacturingDate);
    }
    if (!nullToAbsent || originalManufacturingText != null) {
      map['original_manufacturing_text'] = Variable<String>(
        originalManufacturingText,
      );
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || originalExpiryText != null) {
      map['original_expiry_text'] = Variable<String>(originalExpiryText);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['raw_ocr_text'] = Variable<String>(rawOcrText);
    map['review_status'] = Variable<String>(reviewStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicinesTableCompanion toCompanion(bool nullToAbsent) {
    return MedicinesTableCompanion(
      id: Value(id),
      medicineName: Value(medicineName),
      genericName: genericName == null && nullToAbsent
          ? const Value.absent()
          : Value(genericName),
      strength: strength == null && nullToAbsent
          ? const Value.absent()
          : Value(strength),
      dosageForm: dosageForm == null && nullToAbsent
          ? const Value.absent()
          : Value(dosageForm),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      manufacturingDate: manufacturingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturingDate),
      originalManufacturingText:
          originalManufacturingText == null && nullToAbsent
          ? const Value.absent()
          : Value(originalManufacturingText),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      originalExpiryText: originalExpiryText == null && nullToAbsent
          ? const Value.absent()
          : Value(originalExpiryText),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      rawOcrText: Value(rawOcrText),
      reviewStatus: Value(reviewStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicinesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicinesTableData(
      id: serializer.fromJson<int>(json['id']),
      medicineName: serializer.fromJson<String>(json['medicineName']),
      genericName: serializer.fromJson<String?>(json['genericName']),
      strength: serializer.fromJson<String?>(json['strength']),
      dosageForm: serializer.fromJson<String?>(json['dosageForm']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      manufacturingDate: serializer.fromJson<DateTime?>(
        json['manufacturingDate'],
      ),
      originalManufacturingText: serializer.fromJson<String?>(
        json['originalManufacturingText'],
      ),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      originalExpiryText: serializer.fromJson<String?>(
        json['originalExpiryText'],
      ),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      rawOcrText: serializer.fromJson<String>(json['rawOcrText']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineName': serializer.toJson<String>(medicineName),
      'genericName': serializer.toJson<String?>(genericName),
      'strength': serializer.toJson<String?>(strength),
      'dosageForm': serializer.toJson<String?>(dosageForm),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'manufacturingDate': serializer.toJson<DateTime?>(manufacturingDate),
      'originalManufacturingText': serializer.toJson<String?>(
        originalManufacturingText,
      ),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'originalExpiryText': serializer.toJson<String?>(originalExpiryText),
      'imagePath': serializer.toJson<String?>(imagePath),
      'rawOcrText': serializer.toJson<String>(rawOcrText),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicinesTableData copyWith({
    int? id,
    String? medicineName,
    Value<String?> genericName = const Value.absent(),
    Value<String?> strength = const Value.absent(),
    Value<String?> dosageForm = const Value.absent(),
    Value<String?> batchNumber = const Value.absent(),
    Value<String?> manufacturer = const Value.absent(),
    Value<DateTime?> manufacturingDate = const Value.absent(),
    Value<String?> originalManufacturingText = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    Value<String?> originalExpiryText = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    String? rawOcrText,
    String? reviewStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicinesTableData(
    id: id ?? this.id,
    medicineName: medicineName ?? this.medicineName,
    genericName: genericName.present ? genericName.value : this.genericName,
    strength: strength.present ? strength.value : this.strength,
    dosageForm: dosageForm.present ? dosageForm.value : this.dosageForm,
    batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
    manufacturer: manufacturer.present ? manufacturer.value : this.manufacturer,
    manufacturingDate: manufacturingDate.present
        ? manufacturingDate.value
        : this.manufacturingDate,
    originalManufacturingText: originalManufacturingText.present
        ? originalManufacturingText.value
        : this.originalManufacturingText,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    originalExpiryText: originalExpiryText.present
        ? originalExpiryText.value
        : this.originalExpiryText,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    rawOcrText: rawOcrText ?? this.rawOcrText,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicinesTableData copyWithCompanion(MedicinesTableCompanion data) {
    return MedicinesTableData(
      id: data.id.present ? data.id.value : this.id,
      medicineName: data.medicineName.present
          ? data.medicineName.value
          : this.medicineName,
      genericName: data.genericName.present
          ? data.genericName.value
          : this.genericName,
      strength: data.strength.present ? data.strength.value : this.strength,
      dosageForm: data.dosageForm.present
          ? data.dosageForm.value
          : this.dosageForm,
      batchNumber: data.batchNumber.present
          ? data.batchNumber.value
          : this.batchNumber,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      manufacturingDate: data.manufacturingDate.present
          ? data.manufacturingDate.value
          : this.manufacturingDate,
      originalManufacturingText: data.originalManufacturingText.present
          ? data.originalManufacturingText.value
          : this.originalManufacturingText,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      originalExpiryText: data.originalExpiryText.present
          ? data.originalExpiryText.value
          : this.originalExpiryText,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      rawOcrText: data.rawOcrText.present
          ? data.rawOcrText.value
          : this.rawOcrText,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesTableData(')
          ..write('id: $id, ')
          ..write('medicineName: $medicineName, ')
          ..write('genericName: $genericName, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('manufacturingDate: $manufacturingDate, ')
          ..write('originalManufacturingText: $originalManufacturingText, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('originalExpiryText: $originalExpiryText, ')
          ..write('imagePath: $imagePath, ')
          ..write('rawOcrText: $rawOcrText, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicineName,
    genericName,
    strength,
    dosageForm,
    batchNumber,
    manufacturer,
    manufacturingDate,
    originalManufacturingText,
    expiryDate,
    originalExpiryText,
    imagePath,
    rawOcrText,
    reviewStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicinesTableData &&
          other.id == this.id &&
          other.medicineName == this.medicineName &&
          other.genericName == this.genericName &&
          other.strength == this.strength &&
          other.dosageForm == this.dosageForm &&
          other.batchNumber == this.batchNumber &&
          other.manufacturer == this.manufacturer &&
          other.manufacturingDate == this.manufacturingDate &&
          other.originalManufacturingText == this.originalManufacturingText &&
          other.expiryDate == this.expiryDate &&
          other.originalExpiryText == this.originalExpiryText &&
          other.imagePath == this.imagePath &&
          other.rawOcrText == this.rawOcrText &&
          other.reviewStatus == this.reviewStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicinesTableCompanion extends UpdateCompanion<MedicinesTableData> {
  final Value<int> id;
  final Value<String> medicineName;
  final Value<String?> genericName;
  final Value<String?> strength;
  final Value<String?> dosageForm;
  final Value<String?> batchNumber;
  final Value<String?> manufacturer;
  final Value<DateTime?> manufacturingDate;
  final Value<String?> originalManufacturingText;
  final Value<DateTime?> expiryDate;
  final Value<String?> originalExpiryText;
  final Value<String?> imagePath;
  final Value<String> rawOcrText;
  final Value<String> reviewStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MedicinesTableCompanion({
    this.id = const Value.absent(),
    this.medicineName = const Value.absent(),
    this.genericName = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.manufacturingDate = const Value.absent(),
    this.originalManufacturingText = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.originalExpiryText = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rawOcrText = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MedicinesTableCompanion.insert({
    this.id = const Value.absent(),
    required String medicineName,
    this.genericName = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.manufacturingDate = const Value.absent(),
    this.originalManufacturingText = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.originalExpiryText = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rawOcrText = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : medicineName = Value(medicineName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MedicinesTableData> custom({
    Expression<int>? id,
    Expression<String>? medicineName,
    Expression<String>? genericName,
    Expression<String>? strength,
    Expression<String>? dosageForm,
    Expression<String>? batchNumber,
    Expression<String>? manufacturer,
    Expression<DateTime>? manufacturingDate,
    Expression<String>? originalManufacturingText,
    Expression<DateTime>? expiryDate,
    Expression<String>? originalExpiryText,
    Expression<String>? imagePath,
    Expression<String>? rawOcrText,
    Expression<String>? reviewStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineName != null) 'medicine_name': medicineName,
      if (genericName != null) 'generic_name': genericName,
      if (strength != null) 'strength': strength,
      if (dosageForm != null) 'dosage_form': dosageForm,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (manufacturingDate != null) 'manufacturing_date': manufacturingDate,
      if (originalManufacturingText != null)
        'original_manufacturing_text': originalManufacturingText,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (originalExpiryText != null)
        'original_expiry_text': originalExpiryText,
      if (imagePath != null) 'image_path': imagePath,
      if (rawOcrText != null) 'raw_ocr_text': rawOcrText,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MedicinesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? medicineName,
    Value<String?>? genericName,
    Value<String?>? strength,
    Value<String?>? dosageForm,
    Value<String?>? batchNumber,
    Value<String?>? manufacturer,
    Value<DateTime?>? manufacturingDate,
    Value<String?>? originalManufacturingText,
    Value<DateTime?>? expiryDate,
    Value<String?>? originalExpiryText,
    Value<String?>? imagePath,
    Value<String>? rawOcrText,
    Value<String>? reviewStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MedicinesTableCompanion(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      genericName: genericName ?? this.genericName,
      strength: strength ?? this.strength,
      dosageForm: dosageForm ?? this.dosageForm,
      batchNumber: batchNumber ?? this.batchNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
      originalManufacturingText:
          originalManufacturingText ?? this.originalManufacturingText,
      expiryDate: expiryDate ?? this.expiryDate,
      originalExpiryText: originalExpiryText ?? this.originalExpiryText,
      imagePath: imagePath ?? this.imagePath,
      rawOcrText: rawOcrText ?? this.rawOcrText,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineName.present) {
      map['medicine_name'] = Variable<String>(medicineName.value);
    }
    if (genericName.present) {
      map['generic_name'] = Variable<String>(genericName.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (dosageForm.present) {
      map['dosage_form'] = Variable<String>(dosageForm.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (manufacturingDate.present) {
      map['manufacturing_date'] = Variable<DateTime>(manufacturingDate.value);
    }
    if (originalManufacturingText.present) {
      map['original_manufacturing_text'] = Variable<String>(
        originalManufacturingText.value,
      );
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (originalExpiryText.present) {
      map['original_expiry_text'] = Variable<String>(originalExpiryText.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (rawOcrText.present) {
      map['raw_ocr_text'] = Variable<String>(rawOcrText.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesTableCompanion(')
          ..write('id: $id, ')
          ..write('medicineName: $medicineName, ')
          ..write('genericName: $genericName, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('manufacturingDate: $manufacturingDate, ')
          ..write('originalManufacturingText: $originalManufacturingText, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('originalExpiryText: $originalExpiryText, ')
          ..write('imagePath: $imagePath, ')
          ..write('rawOcrText: $rawOcrText, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicinesTableTable medicinesTable = $MedicinesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [medicinesTable];
}

typedef $$MedicinesTableTableCreateCompanionBuilder =
    MedicinesTableCompanion Function({
      Value<int> id,
      required String medicineName,
      Value<String?> genericName,
      Value<String?> strength,
      Value<String?> dosageForm,
      Value<String?> batchNumber,
      Value<String?> manufacturer,
      Value<DateTime?> manufacturingDate,
      Value<String?> originalManufacturingText,
      Value<DateTime?> expiryDate,
      Value<String?> originalExpiryText,
      Value<String?> imagePath,
      Value<String> rawOcrText,
      Value<String> reviewStatus,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$MedicinesTableTableUpdateCompanionBuilder =
    MedicinesTableCompanion Function({
      Value<int> id,
      Value<String> medicineName,
      Value<String?> genericName,
      Value<String?> strength,
      Value<String?> dosageForm,
      Value<String?> batchNumber,
      Value<String?> manufacturer,
      Value<DateTime?> manufacturingDate,
      Value<String?> originalManufacturingText,
      Value<DateTime?> expiryDate,
      Value<String?> originalExpiryText,
      Value<String?> imagePath,
      Value<String> rawOcrText,
      Value<String> reviewStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$MedicinesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTableTable> {
  $$MedicinesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get manufacturingDate => $composableBuilder(
    column: $table.manufacturingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalManufacturingText => $composableBuilder(
    column: $table.originalManufacturingText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalExpiryText => $composableBuilder(
    column: $table.originalExpiryText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawOcrText => $composableBuilder(
    column: $table.rawOcrText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicinesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTableTable> {
  $$MedicinesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get manufacturingDate => $composableBuilder(
    column: $table.manufacturingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalManufacturingText => $composableBuilder(
    column: $table.originalManufacturingText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalExpiryText => $composableBuilder(
    column: $table.originalExpiryText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawOcrText => $composableBuilder(
    column: $table.rawOcrText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicinesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTableTable> {
  $$MedicinesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get manufacturingDate => $composableBuilder(
    column: $table.manufacturingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalManufacturingText => $composableBuilder(
    column: $table.originalManufacturingText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalExpiryText => $composableBuilder(
    column: $table.originalExpiryText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get rawOcrText => $composableBuilder(
    column: $table.rawOcrText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicinesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicinesTableTable,
          MedicinesTableData,
          $$MedicinesTableTableFilterComposer,
          $$MedicinesTableTableOrderingComposer,
          $$MedicinesTableTableAnnotationComposer,
          $$MedicinesTableTableCreateCompanionBuilder,
          $$MedicinesTableTableUpdateCompanionBuilder,
          (
            MedicinesTableData,
            BaseReferences<
              _$AppDatabase,
              $MedicinesTableTable,
              MedicinesTableData
            >,
          ),
          MedicinesTableData,
          PrefetchHooks Function()
        > {
  $$MedicinesTableTableTableManager(
    _$AppDatabase db,
    $MedicinesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> medicineName = const Value.absent(),
                Value<String?> genericName = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String?> dosageForm = const Value.absent(),
                Value<String?> batchNumber = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<DateTime?> manufacturingDate = const Value.absent(),
                Value<String?> originalManufacturingText = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> originalExpiryText = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> rawOcrText = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MedicinesTableCompanion(
                id: id,
                medicineName: medicineName,
                genericName: genericName,
                strength: strength,
                dosageForm: dosageForm,
                batchNumber: batchNumber,
                manufacturer: manufacturer,
                manufacturingDate: manufacturingDate,
                originalManufacturingText: originalManufacturingText,
                expiryDate: expiryDate,
                originalExpiryText: originalExpiryText,
                imagePath: imagePath,
                rawOcrText: rawOcrText,
                reviewStatus: reviewStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String medicineName,
                Value<String?> genericName = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String?> dosageForm = const Value.absent(),
                Value<String?> batchNumber = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<DateTime?> manufacturingDate = const Value.absent(),
                Value<String?> originalManufacturingText = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> originalExpiryText = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> rawOcrText = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => MedicinesTableCompanion.insert(
                id: id,
                medicineName: medicineName,
                genericName: genericName,
                strength: strength,
                dosageForm: dosageForm,
                batchNumber: batchNumber,
                manufacturer: manufacturer,
                manufacturingDate: manufacturingDate,
                originalManufacturingText: originalManufacturingText,
                expiryDate: expiryDate,
                originalExpiryText: originalExpiryText,
                imagePath: imagePath,
                rawOcrText: rawOcrText,
                reviewStatus: reviewStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicinesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicinesTableTable,
      MedicinesTableData,
      $$MedicinesTableTableFilterComposer,
      $$MedicinesTableTableOrderingComposer,
      $$MedicinesTableTableAnnotationComposer,
      $$MedicinesTableTableCreateCompanionBuilder,
      $$MedicinesTableTableUpdateCompanionBuilder,
      (
        MedicinesTableData,
        BaseReferences<_$AppDatabase, $MedicinesTableTable, MedicinesTableData>,
      ),
      MedicinesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicinesTableTableTableManager get medicinesTable =>
      $$MedicinesTableTableTableManager(_db, _db.medicinesTable);
}
