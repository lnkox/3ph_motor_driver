Attribute VB_Name = "Module1"
Public Type Point
    X As Single
    Y As Single
    ncur As Integer
    npath As Integer
    discrit As Integer
    npoint As Integer
End Type
Public Function get_bline(ByRef PA() As Point) As Point()
Dim i As Long, j As Long, t As Point, M() As Point
discrit = PA(0).discrit
ReDim out(discrit) As Point
out(0) = PA(0)
For i = 1 To discrit
    ReDim M(UBound(PA)) As Point
    For j = 0 To UBound(PA)
        M(j) = PA(j)
    Next
    Do While UBound(M) > 0
        For j = 0 To UBound(M) - 1
            M(j) = LERP(M(j), M(j + 1), i / discrit)
        Next
        ReDim Preserve M(UBound(M) - 1)
    Loop
    DrawWidth = 2
    out(i) = M(0)

Next


get_bline = out
End Function

Private Function LERP(P1 As Point, P2 As Point, ByVal S As Single) As Point
LERP.X = (P2.X - P1.X) * S + P1.X
LERP.Y = (P2.Y - P1.Y) * S + P1.Y
End Function
