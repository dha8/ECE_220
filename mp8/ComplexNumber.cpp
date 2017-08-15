#include "ComplexNumber.h"

//constructors
ComplexNumber::ComplexNumber() : 
    realComponent(0),imagComponent(0) { NumberType = COMPLEX; }
ComplexNumber::ComplexNumber(double real, double imag) : 
    realComponent(real), imagComponent(imag) { NumberType = COMPLEX; }

//setters & getters
void ComplexNumber::set_realComponent(double rval){ realComponent = rval; }

void ComplexNumber::set_imagComponent(double ival){ imagComponent = ival; }

double ComplexNumber::get_realComponent(void) const{ return realComponent; }

double ComplexNumber::get_imagComponent(void) const{ return imagComponent; }

void ComplexNumber::set_value(double rval, double ival){
    realComponent = rval;
    imagComponent = ival;
}

//Class member fxns
double ComplexNumber::magnitude() { 
    return sqrt(pow(realComponent,2)+pow(imagComponent,2)); 
}

//Overloaded operators for Complex & Complex
ComplexNumber ComplexNumber::operator+(const ComplexNumber& arg){
    return ComplexNumber(realComponent+arg.realComponent, 
            imagComponent+arg.imagComponent);
}

ComplexNumber ComplexNumber::operator-(const ComplexNumber& arg){
    return ComplexNumber(realComponent-arg.realComponent, 
            imagComponent-arg.imagComponent);
}

ComplexNumber ComplexNumber::operator*(const ComplexNumber& arg){
    double real = 
        realComponent*arg.realComponent - imagComponent*arg.imagComponent;
    double imag = 
        realComponent*arg.imagComponent + imagComponent*arg.realComponent;
    return ComplexNumber(real, imag);
}

ComplexNumber ComplexNumber::operator/(const ComplexNumber& arg){
    //multiply by conjugate
    ComplexNumber conjugate = 
        ComplexNumber(arg.realComponent,-arg.imagComponent);
    ComplexNumber numerator = *this * conjugate;
    ComplexNumber denominator = ComplexNumber(arg.realComponent, arg.imagComponent) * conjugate;
    numerator.realComponent /= denominator.realComponent;
    numerator.imagComponent /= denominator.realComponent;
    return numerator;
}

//Complex & Real
ComplexNumber ComplexNumber::operator+(const RealNumber& arg){
    return ComplexNumber(realComponent+arg.get_value(),imagComponent);
}

ComplexNumber ComplexNumber::operator-(const RealNumber& arg){
    return ComplexNumber(realComponent-arg.get_value(),imagComponent);
}

ComplexNumber ComplexNumber::operator*(const RealNumber& arg){
    return ComplexNumber(realComponent*arg.get_value(),
            imagComponent*arg.get_value());
}

ComplexNumber ComplexNumber::operator/(const RealNumber& arg){
    return ComplexNumber(realComponent/arg.get_value(),
            imagComponent/arg.get_value());
}

//Complex & rational
ComplexNumber ComplexNumber::operator+(const RationalNumber& arg){
    return ComplexNumber(realComponent+arg.decimal_value(),imagComponent);
}

ComplexNumber ComplexNumber::operator-(const RationalNumber& arg){
    return ComplexNumber(realComponent-arg.decimal_value(),imagComponent);
}

ComplexNumber ComplexNumber::operator*(const RationalNumber& arg){
    return ComplexNumber(realComponent*arg.decimal_value(),
            imagComponent*arg.decimal_value());
}

ComplexNumber ComplexNumber::operator/(const RationalNumber& arg){
    return ComplexNumber(realComponent/arg.decimal_value(),
            imagComponent/arg.decimal_value());
}

//to_String converts real and imaginary components to string of type a+bi
string ComplexNumber::to_String(void){
	stringstream my_output;
	my_output << realComponent;
	if(imagComponent >= 0){
		my_output << " + " << imagComponent << "i";
	}
	else if(imagComponent < 0){
		my_output << "-" << imagComponent*(-1) << "i";
	}
	return my_output.str();
}
