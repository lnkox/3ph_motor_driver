VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Налатування АЧХ"
   ClientHeight    =   7650
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   11700
   LinkTopic       =   "Form1"
   ScaleHeight     =   7650
   ScaleWidth      =   11700
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox outt 
      Height          =   7095
      Left            =   9120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   7
      Top             =   480
      Width           =   2535
   End
   Begin VB.ListBox List1 
      Height          =   7080
      Left            =   7800
      TabIndex        =   6
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton gen_tab 
      Caption         =   "Згенерувати таблиці"
      Height          =   255
      Left            =   7800
      TabIndex        =   5
      Top             =   120
      Width           =   3855
   End
   Begin VB.PictureBox char_pic 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      DrawWidth       =   3
      ForeColor       =   &H80000008&
      Height          =   7600
      Left            =   0
      Picture         =   "Form1.frx":0000
      ScaleHeight     =   7575
      ScaleWidth      =   7575
      TabIndex        =   0
      Top             =   0
      Width           =   7600
      Begin VB.PictureBox point_marker_btn 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFF00&
         ForeColor       =   &H80000008&
         Height          =   100
         Index           =   4
         Left            =   120
         ScaleHeight     =   75
         ScaleWidth      =   75
         TabIndex        =   4
         Top             =   240
         Width           =   100
      End
      Begin VB.PictureBox point_marker_btn 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFF00&
         ForeColor       =   &H80000008&
         Height          =   100
         Index           =   1
         Left            =   360
         ScaleHeight     =   75
         ScaleWidth      =   75
         TabIndex        =   3
         Top             =   480
         Width           =   100
      End
      Begin VB.PictureBox point_marker_btn 
         Appearance      =   0  'Flat
         BackColor       =   &H0080C0FF&
         ForeColor       =   &H80000008&
         Height          =   100
         Index           =   2
         Left            =   120
         ScaleHeight     =   75
         ScaleWidth      =   75
         TabIndex        =   2
         Top             =   480
         Width           =   100
      End
      Begin VB.PictureBox point_marker_btn 
         Appearance      =   0  'Flat
         BackColor       =   &H0080C0FF&
         ForeColor       =   &H80000008&
         Height          =   100
         Index           =   3
         Left            =   240
         ScaleHeight     =   75
         ScaleWidth      =   75
         TabIndex        =   1
         Top             =   240
         Width           =   100
      End
      Begin VB.Shape start_path_marker 
         BackColor       =   &H00C00000&
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00C0C000&
         Height          =   120
         Left            =   -200
         Shape           =   3  'Circle
         Top             =   1080
         Width           =   75
      End
      Begin VB.Shape end_path_marker 
         BackColor       =   &H00FFFF00&
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00C00000&
         Height          =   120
         Left            =   -200
         Shape           =   3  'Circle
         Top             =   1800
         Width           =   75
      End
      Begin VB.Shape marker1 
         BackColor       =   &H0000FFFF&
         BackStyle       =   1  'Opaque
         BorderColor     =   &H000000FF&
         Height          =   120
         Left            =   -200
         Shape           =   3  'Circle
         Top             =   720
         Width           =   75
      End
      Begin VB.Shape marker2 
         BackColor       =   &H0000FFFF&
         BackStyle       =   1  'Opaque
         BorderColor     =   &H000000FF&
         Height          =   120
         Left            =   -200
         Shape           =   3  'Circle
         Top             =   600
         Width           =   75
      End
      Begin VB.Line bize_line_34 
         BorderColor     =   &H00000000&
         X1              =   600
         X2              =   600
         Y1              =   4080
         Y2              =   4320
      End
      Begin VB.Line bize_line_12 
         BorderColor     =   &H00000000&
         X1              =   360
         X2              =   360
         Y1              =   4080
         Y2              =   4320
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim qw(4) As Point
Dim oldpos As Point
Dim bl() As Point
Dim cnt As Integer



Private Sub Form_Load()

cnt = 33

qw(0).X = 10 * 15
qw(0).Y = 350 * 15
qw(1).X = 10 * 15
qw(1).Y = 350 * 15
qw(2).X = 100 * 15
qw(2).Y = 200 * 15
qw(3).X = 400 * 15
qw(3).Y = 300 * 15
qw(4).X = 500 * 15
qw(4).Y = 0
qw(0).discrit = 2000
point_marker_btn(1).Left = qw(1).X
point_marker_btn(1).Top = qw(1).Y
point_marker_btn(2).Left = qw(2).X
point_marker_btn(2).Top = qw(2).Y
point_marker_btn(3).Left = qw(3).X
point_marker_btn(3).Top = qw(3).Y
point_marker_btn(4).Left = qw(4).X
point_marker_btn(4).Top = qw(4).Y
bize_line_12.X1 = point_marker_btn(1).Left
bize_line_12.Y1 = point_marker_btn(1).Top
bize_line_12.X2 = point_marker_btn(2).Left
bize_line_12.Y2 = point_marker_btn(2).Top
bize_line_34.X1 = point_marker_btn(3).Left
bize_line_34.Y1 = point_marker_btn(3).Top
bize_line_34.X2 = point_marker_btn(4).Left
bize_line_34.Y2 = point_marker_btn(4).Top
redraw_char
End Sub

Private Sub gen_tab_Click()
out = "flash signed char sineTable[][34]={" & vbNewLine
nzn = 1
List1.Clear
For X = 0 To UBound(bl)

If nzn = Int((bl(X).X / 15) / 10) Then
    nzn = nzn + 1
    Y = 100 - Int((bl(X).Y / 15) / 5)
    If Y < 1 Then Y = 1
    List1.AddItem Int((bl(X).X / 15) / 10) & " - " & Y
out = out & "{"
    For a = 0 To cnt - 1
        trad = (a / cnt) * 3.1415
        sinv = Sin(trad)
        Sina = Int(sinv * Y)
        out = out & Int(Sina * 1.25) & ","
        char_pic.DrawWidth = 3
        char_pic.PSet ((a * 1.5) * 15 * 10, 500 * 15 - Sina * 15 * 5), RGB(nzn * 5, 250 - nzn * 3, 200)
    Next
out = out & "}," & vbNewLine
    DoEvents

End If
Next
outt = out & "};"
End Sub

Private Sub point_marker_btn_MouseDown(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
oldpos.X = X
oldpos.Y = Y
End Sub

Private Sub point_marker_btn_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 0 Then Exit Sub
If Index = 2 Or Index = 3 Then point_marker_btn(Index).Left = point_marker_btn(Index).Left + X - oldpos.X
point_marker_btn(Index).Top = point_marker_btn(Index).Top + Y - oldpos.Y


bize_line_12.X1 = point_marker_btn(1).Left
bize_line_12.Y1 = point_marker_btn(1).Top
bize_line_12.X2 = point_marker_btn(2).Left
bize_line_12.Y2 = point_marker_btn(2).Top
bize_line_34.X1 = point_marker_btn(3).Left
bize_line_34.Y1 = point_marker_btn(3).Top
bize_line_34.X2 = point_marker_btn(4).Left
bize_line_34.Y2 = point_marker_btn(4).Top
If Index = 1 Then
    qw(1).X = (point_marker_btn(Index).Left)
    qw(1).Y = (point_marker_btn(Index).Top)
    qw(0).X = (point_marker_btn(Index).Left)
    qw(0).Y = (point_marker_btn(Index).Top)
End If
If Index = 2 Then
    qw(2).X = (point_marker_btn(Index).Left)
    qw(2).Y = (point_marker_btn(Index).Top)
End If
If Index = 3 Then
    qw(3).X = (point_marker_btn(Index).Left)
    qw(3).Y = (point_marker_btn(Index).Top)
End If
If Index = 4 Then
    qw(4).X = (point_marker_btn(Index).Left)
    qw(4).Y = (point_marker_btn(Index).Top)
    
End If
redraw_char

End Sub
Private Sub redraw_char()
char_pic.Cls
char_pic.DrawWidth = 3
    bl() = get_bline(qw)

    For X = 1 To UBound(bl)
    nzn = Int((bl(X).X / 15) / 10)
        char_pic.Line (bl(X - 1).X, bl(X - 1).Y)-(bl(X).X, bl(X).Y), RGB(nzn * 5, 250 - nzn * 3, 200)
    Next



End Sub

