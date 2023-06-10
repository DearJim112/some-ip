
#include <QApplication> 
#include <QPainter>
#include <QPixmap>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // 创建QPixmap作为绘图设备
    QPixmap pix(600, 400);
    pix.fill(Qt::white);
    
    // 创建QPainter在pixmap上绘图
    QPainter painter(&pix);
    
    // 定义四个点 
    QPointF points[4] = {
        {100, 100}, {200, 150}, {250, 250}, {150, 200}
    };
    
    // 绘制四边形
    painter.drawPolygon(points, 4);
    
    // 设置QPen控制线条样式
    QPen pen;
    pen.setColor(Qt::blue);
    pen.setWidth(3);
    painter.setPen(pen);
    
    // 绘制四边形边线 
    painter.drawPolyline(points, 4);
    
    // 保存结果到文件
    pix.save("image.png");
    
    return 0;
}
