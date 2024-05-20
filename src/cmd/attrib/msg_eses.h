/*
 * Copyright 2022, 2024 S. V. Nickolas.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the Software), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#ifndef _H_MESSAGES_
#define _H_MESSAGES_
const char *m_synerr ="Error de sintaxis\r\n",
           *m_switch ="Conmutaci¢n no v lida - /",
           *m_args   ="Demasiados par metros\r\n",
           *m_ram    ="Memoria insuficiente\r\n",
           *m_nofiles="No se encontr¢ ning£n archivo\r\n",
           *m_space  ="  ",
           *m_crlf   ="\r\n";

/*
 * Table of relevant MS-DOS error messages.
 * 
 * The order does not actually matter (for compression purposes) but it must
 * end with 0x00 and "Unknown error" so that the "print error message" routine
 * works correctly.
 */
struct
{
 unsigned char err;
 const char *msg;
} errtab[]={
 0x01, "Funci¢n no v lida",
 0x02, "Archivo no encontrado",
 0x03, "V¡a de acceso no v lida",
 0x04, "Demasiados archivos abiertos",
 0x05, "Acceso denegado",
 0x06, "Manejo no v lido",
 0x08, "Memoria insuficiente",
 0x09, "Direcci¢n no v lida de bloque de memoria",
 0x0F, "Especificaci¢n de unidad no v lida",
 0x12, "No hay m s archivos",
 0x13, "Error de protecci¢n contra grabaci¢n",
 0x14, "Unidad no v lida",
 0x15, "Unidad no preparado",
 0x16, "Petici¢n de dispositivo no v lida",
 0x17, "Error CRC de datos",
 0x19, "Error de b£squeda",
 0x1A, "Tipo de soporte no v lido",
 0x1B, "Sector no encontrado",
 0x1D, "Falta de grabar",
 0x1E, "Falta de leer",
 0x1F, "Error de E/S",
 0x20, "Violaci¢n de compartir",
 0x21, "Violaci¢n de bloqueo",
 0x22, "Cambio de diskette no v lido",
 0x24, "Desbordamiento del buffer de Share",
 0x26, "Fuera de entrada",
 0x27, "Espacio insuficiente en disco",
 0x50, "Archivo ya existe",
 0x53, "Error en INT 24",
 0x00, "Error no conocido"
};
#endif /* _H_MESSAGES_ */
