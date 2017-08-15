#include "RationalNumber.h"

//Constructors
RationalNumber::RationalNumber() : numerator(0), denominator(1) {
    NumberType = RATIONAL;
}
RationalNumber::RationalNumber(int numer, int denom) :numerator(numer), denominator(denom) {
    NumberType = RATIONAL;
}

//Setters and getters
void RationalNumber::set_numerator(int numer){  numerator = numer; } 
void RationalNumber::set_denominator(int denom){ denominator = denom; }
int RationalNumber::get_numerator(void) const{ return numerator; }
int RationalNumber::get_denominator(void) const{ return denominator; }

//class member fxns
void RationalNumber::set_value(int numer, int denom){
    numerator = numer; 
    denominator = denom;
}

int RationalNumber::gcd(int a, int b){
    if(a == 0) return b;
    return gcd(b % a, a); 
}

double RationalNumber::magnitude(){
    double retval =  double(numerator)/double(denominator);
    retval = (retval<0) ? retval*-1.0 : retval;
    return retval; 
}

double RationalNumber::decimal_value() const{
    return double(numerator)/double(denominator);   
}

//added helper fxn
void RationalNumber::reduce(){
    if(denominator < 1) return;
    for(int i=denominator;i>0;--i){
        if(numerator % i == 0 && denominator % i == 0){
            numerator /= i;
            denominator /= i;
            return;
        }
    }
}

// RationalNumber & RationalNumber
RationalNumber RationalNumber::operator+(const RationalNumber& arg){
    RationalNumber temp = RationalNumber(
           numerator*arg.denominator+arg.numerator*denominator,
           denominator*arg.denominator);
    temp.reduce();
    return temp; 
}

RationalNumber RationalNumber::operator-(const RationalNumber& arg){ 
    RationalNumber temp = RationalNumber(
           numerator*arg.denominator-arg.numerator*denominator,
           denominator*arg.denominator);
    temp.reduce();
    return temp; 
}

RationalNumber RationalNumber::operator*(const RationalNumber& arg){ 
    RationalNumber temp = RationalNumber(
           numerator*arg.numerator, denominator*arg.denominator);
    temp.reduce();
    return temp; 
}

RationalNumber RationalNumber::operator/(const RationalNumber& arg){
    RationalNumber temp = RationalNumber(
           numerator*arg.denominator, denominator*arg.numerator);
    temp.reduce();
    return temp; 
}

//Rational & Complex
ComplexNumber RationalNumber::operator+(const ComplexNumber& arg){
    return ComplexNumber(arg.get_realComponent()+decimal_value(),
            arg.get_imagComponent());
}

ComplexNumber RationalNumber::operator-(const ComplexNumber& arg){
    return ComplexNumber(decimal_value()-arg.get_realComponent(),
            (-1.0)*arg.get_imagComponent());
}

ComplexNumber RationalNumber::operator*(const ComplexNumber& arg){
    return ComplexNumber(arg.get_realComponent()*decimal_value(),
            arg.get_imagComponent()*decimal_value());
}

ComplexNumber RationalNumber::operator/(const ComplexNumber& arg){
    double rc = decimal_value()*arg.get_realComponent();
    double ic = decimal_value()*arg.get_imagComponent()*(-1.);
    double d = arg.get_realComponent()*arg.get_realComponent()+arg.get_imagComponent()*arg.get_imagComponent();
    return ComplexNumber(rc/d, ic/d);
}

//Rational & Real
RealNumber RationalNumber::operator+(const RealNumber& arg){
    return RealNumber(decimal_value()+arg.get_value());
}

RealNumber RationalNumber::operator-(const RealNumber& arg){
    return RealNumber(decimal_value()-arg.get_value());
}

RealNumber RationalNumber::operator*(const RealNumber& arg){
    return RealNumber(decimal_value()*arg.get_value());
}

RealNumber RationalNumber::operator/(const RealNumber& arg){
    return RealNumber(decimal_value()/arg.get_value());
}

//to_String converts numerator and denominator to string of type num/denom
string RationalNumber::to_String(void){
	stringstream my_output;
	my_output << numerator << "/" << denominator;
	return my_output.str();
}

