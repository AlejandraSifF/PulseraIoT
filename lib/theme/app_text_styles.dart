import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {

  /// 🟣 TITULOS (AppBar o encabezados)
  static const TextStyle appBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.colorBotonPrincipal,
  );

  /// 🟣 SUBTITULOS / LABELS GRANDES
  static const TextStyle subtitulo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textoOscuro,
  );

  /// 🟣 TEXTO NORMAL
  static const TextStyle normal = TextStyle(
    fontSize: 14,
    color: AppColors.textoMedio,
  );

  /// 🟣 TEXTO SECUNDARIO
  static const TextStyle secundario = TextStyle(
    fontSize: 12,
    color: AppColors.textoSecundario,
  );

  /// 🟣 TEXTO PEQUEÑO
  static const TextStyle pequeno = TextStyle(
    fontSize: 11,
    color: AppColors.textoSecundario,
  );

  /// 🟣 LABELS (inputs)
  static const TextStyle label = TextStyle(
    fontSize: 14,
    color: AppColors.textoLabel,
  );

  /// 🟣 BOTONES
  static const TextStyle boton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textoClaro,
  );

  /// 🟣 ITEMS DE LISTA (como menú / configuración)
static const TextStyle listItem = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: AppColors.textoOscuro,
);

/// 🟣 APPBAR CLARO (cuando fondo es colorPrincipal)
static const TextStyle appBarLight = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: AppColors.textoClaro,
);

/// 🟣 SECCIÓN (ej: "Número", "Correo")
static const TextStyle sectionTitle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: AppColors.textoOscuro,
);

/// 🟣 TEXTO DE VALOR (ej: teléfono, correo)
static const TextStyle value = TextStyle(
  fontSize: 13,
  color: AppColors.textoSecundario,
);

/// 🟣 TEXTO LARGO (párrafos)
static const TextStyle paragraph = TextStyle(
  fontSize: 16,
  color: AppColors.textoMedio,
  height: 1.4,
);

/// 🟣 TÍTULOS GRANDES (secciones tipo "Información que recopilamos")
static const TextStyle heading = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: AppColors.textoMedio,
);

/// 🟣 TÍTULO DESTACADO (color principal)
static const TextStyle headingPrimary = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: AppColors.colorPrincipal,
);

/// 🟣 FECHA / TEXTO DESTACADO
static const TextStyle highlight = TextStyle(
  fontSize: 16,
  color: AppColors.colorPrincipal,
  fontWeight: FontWeight.w500,
);

/// 🟣 TEXTO DE OPCIONES (radio buttons)
static const TextStyle option = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: AppColors.textoMedio,
);

/// 🟣 TEXTO BOTÓN GRANDE
static const TextStyle buttonLarge = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: AppColors.textoClaro,
);
}