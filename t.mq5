//+------------------------------------------------------------------+
//|                                            t.mq5 |
//|                                    Copyright 2025, Yousuf Mesalm. |
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Yousuf Mesalm. www.yousufmesalm.com | WhatsApp +201006179048"
#property link      "https://www.yousufmesalm.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
//--- available signals
#include <Expert\Signal\SignalTriangularNumbers.mqh>
//--- available trailing
#include <Expert\Trailing\TrailingFixedPips.mqh>
//--- available money management
#include <Expert\Money\MoneyFixedRisk.mqh>
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
//--- inputs for expert
input string Expert_Title                  ="t";   // Document name
ulong        Expert_MagicNumber            =27318; //
bool         Expert_EveryTick              =false; //
//--- inputs for main signal
input int    Signal_ThresholdOpen          =10;    // Signal threshold value to open [0...100]
input int    Signal_ThresholdClose         =10;    // Signal threshold value to close [0...100]
input double Signal_PriceLevel             =0.0;   // Price level to execute a deal
input double Signal_StopLevel              =50.0;  // Stop Loss level (in points)
input double Signal_TakeLevel              =50.0;  // Take Profit level (in points)
input int    Signal_Expiration             =4;     // Expiration of pending orders (in bars)
input int    Signal_Tri_m_Numbers          =10000; // Triangular Numbers(10000) Numerical  Numbers
input double Signal_Tri_Weight             =1.0;   // Triangular Numbers(10000) Weight [0...1.0]
//--- inputs for trailing
input int    Trailing_FixedPips_StopLevel  =30;    // Stop Loss trailing level (in points)
input int    Trailing_FixedPips_ProfitLevel=50;    // Take Profit trailing level (in points)
//--- inputs for money
input double Money_FixRisk_Percent         =2.0;   // Risk percentage
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
CExpert ExtExpert;
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Creating signal
   CExpertSignal *signal=new CExpertSignal;
   if(signal==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//---
   ExtExpert.InitSignal(signal);
   signal.ThresholdOpen(Signal_ThresholdOpen);
   signal.ThresholdClose(Signal_ThresholdClose);
   signal.PriceLevel(Signal_PriceLevel);
   signal.StopLevel(Signal_StopLevel);
   signal.TakeLevel(Signal_TakeLevel);
   signal.Expiration(Signal_Expiration);
//--- Creating filter CTriangularSignal
   CTriangularSignal *filter0=new CTriangularSignal;
   if(filter0==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter0");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter0);
//--- Set filter parameters
   filter0.Set_Numbers(Signal_Tri_m_Numbers);
   filter0.Weight(Signal_Tri_Weight);
//--- Creation of trailing object
   CTrailingFixedPips *trailing=new CTrailingFixedPips;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set trailing parameters
   trailing.StopLevel(Trailing_FixedPips_StopLevel);
   trailing.ProfitLevel(Trailing_FixedPips_ProfitLevel);
//--- Creation of money object
   CMoneyFixedRisk *money=new CMoneyFixedRisk;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set money parameters
   money.Percent(Money_FixRisk_Percent);
//--- Check all trading objects parameters
   if(!ExtExpert.ValidationSettings())
     {
      //--- failed
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- ok
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ExtExpert.Deinit();
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnTick()
  {
   ExtExpert.OnTick();
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnTrade()
  {
   ExtExpert.OnTrade();
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnTimer()
  {
   ExtExpert.OnTimer();
  }
//+------------------------------------------------------------------+
