VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6720
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   3165
   LinkTopic       =   "Form1"
   ScaleHeight     =   6720
   ScaleWidth      =   3165
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox nl 
      Caption         =   "newline"
      Height          =   255
      Left            =   2160
      TabIndex        =   10
      Top             =   1200
      Width           =   975
   End
   Begin VB.TextBox out 
      Height          =   4215
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   9
      Top             =   2400
      Width           =   2895
   End
   Begin VB.TextBox tabv 
      Height          =   375
      Left            =   1680
      TabIndex        =   7
      Text            =   ","
      Top             =   1080
      Width           =   375
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Побудувати"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   1680
      Width           =   1935
   End
   Begin VB.TextBox amp 
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Text            =   "125"
      Top             =   360
      Width           =   1335
   End
   Begin VB.TextBox cnt 
      Height          =   375
      Left            =   1680
      TabIndex        =   2
      Text            =   "256"
      Top             =   360
      Width           =   1335
   End
   Begin VB.TextBox midr 
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Text            =   "0"
      Top             =   1080
      Width           =   1335
   End
   Begin VB.Label Label7 
      Caption         =   "Роздільник"
      Height          =   255
      Left            =   1680
      TabIndex        =   8
      Top             =   840
      Width           =   2775
   End
   Begin VB.Label Label4 
      Caption         =   "Амплітуда"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "Кількість значень"
      Height          =   255
      Left            =   1680
      TabIndex        =   3
      Top             =   120
      Width           =   2775
   End
   Begin VB.Label Label2 
      Caption         =   "Середній рівень"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   840
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim arrData()
Private Sub Command1_Click()
out = ""
ReDim arrData(cnt, 1)
For a = 0 To cnt
trad = (a / cnt) * 2 * 3.1415
sinv = Sin(trad)
sina = Int(sinv * amp) + Val(midr)
If nl.Value = 1 Then
    out = out & sina & tabv & vbNewLine
Else
    out = out & sina & tabv
End If
arrData(a, 0) = a
arrData(a, 1) = sina

Next

End Sub

