#include <iostream>
#include <math.h>  // needed for M_PI
#include <assert.h>

using namespace std;

class circle
{
  protected:
    float x, y; // center
    float radius;  // radius

  public:
    // constructors
    circle() { x = y = 0.0; radius = 1.0; }
    circle(float cx, float cy) { x = cx; y = cy; radius = 1.0; }

    // additional constructors   IMPLEMENT ME
    circle(float cx, float cy, float r) : x(cx), y(cy), radius(r) {
		assert(r > 0.0);
	}
    // set methods IMPLEMENT ME
    void setX(float cx) { x = cx; }
    void setY(float cy) { y = cy; }
    void setRadius(float r) { radius = r; assert(r>0.0); }
    // get methods IMPLEMENT ME
    float getX() { return x; }
    float getY() { return y; }
    float getRadius() { return radius; }
    // compute methods IMPLEMENT ME
    float computeArea() { return M_PI * radius * radius; }
	float computePerimeter() { return 2* M_PI*radius; }
    // operators IMPLEMENT ME
    circle operator* (float scaler) {
	    assert(scaler>0.0);
		return circle(x, y, radius * scaler); 
    }
	bool operator> (const circle& b){ return (radius > b.radius); }
    // I/O (already implemented, do not modify it)
    friend ostream& operator<<(ostream& os, const circle& b);  
};


ostream& operator<<(ostream& os, const circle& b)  
{  
    os << "(" << b.x << "," << b.y << ") " << b.radius << endl;  
    return os;  
}  

int main()
{
    circle a;
    circle b(2.0, 3.0);
    circle c(4.0, 5.0, 2.5);
    circle d(b);

    // test for << operator and constructors
    /* should print this:
    (0,0) 1
    (2,3) 1
    (4,5) 2.5
    (2,3) 1
    */
    cout << a << b << c << d;

    // test for > operator
    cout << (a > c) << endl;  // should print 0
    cout << (c > a) << endl;  // should print 1

    // test for * operator
    cout << b * 2.0;  // should print (2,3) 2

    // test for area and perimeter
    // should print area=3.14159, perimeter=6.28319
    cout << "area=" << a.computeArea() << ", perimeter=" << a.computePerimeter() << endl;

    // test for set methods
    b.setX(10.0);
    b.setY(-10.0);
    b.setRadius(2.0);
    cout << b; // should print (10,-10) 2

    // test for get methods
    // should print 10 -10 2
    cout << b.getX() << " " << b.getY() << " " << b.getRadius() << endl;

    // tests for invalid circle (radius <= 0)

    circle error1(0.0, 0.0, 0.0);
    /* should print something similar to this:
       a.out: part2.cpp:17: circle::circle(float, float, float): Assertion `r > 0.0' failed.
       Aborted
    */

    circle error2;
    error2.setRadius(-2.0);
    /* should print somehting similar to this:
       a.out: part2.cpp:23: void circle::setRadius(float): Assertion `r > 0.0' failed.
       Aborted
    */

    circle error3;
    error3 = a * -2.0;
    /* should print somehting similar to this:
       a.out: part2.cpp:35: circle circle::operator*(float): Assertion `scaler > 0.0' failed.
       Aborted
    */

    return 0;
}


