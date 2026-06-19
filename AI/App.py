import streamlit as st
import pandas as pd
import numpy as np
import joblib
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime
import time
import warnings
warnings.filterwarnings('ignore')

# ================================
# 🎨 CONFIGURATION
# ================================
st.set_page_config(
    page_title="Smart Water Bottle | AI Hydration Assistant",
    page_icon="💧",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ================================
# 🎯 CUSTOM CSS - Cyan Gradient Design (Matching Tab)
# ================================
st.markdown("""
<style>
    /* Main Container */
    .main {
        background-color: #f8fafc;
    }
    
    /* Professional Header */
    .main-header {
        font-size: 3.5rem;
        background: linear-gradient(90deg, #0072ff 0%, #00c6ff 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        text-align: center;
        font-weight: 800;
        margin-bottom: 0.5rem;
    }
        .sub-header {
        font-size: 1.2rem;
        color: #64748b;
        text-align: center;
        margin-bottom: 2rem;
        font-weight: 400;
    }
    
    /* 🔵 CYAN GRADIENT BUTTON & TAB STYLING (Matching Prediction Results Tab) */
    .stButton > button, .stTabs [aria-selected="true"] {
        background: linear-gradient(90deg, #0072ff 0%, #00c6ff 100%) !important;
        color: white !important;
        border: none !important;
        padding: 0.8rem 2rem !important;
        border-radius: 12px !important;
        font-weight: 600 !important;
        transition: all 0.3s ease !important;
        box-shadow: 0 4px 15px rgba(0, 114, 255, 0.3) !important;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* Hover Effects for Button and Selected Tab */
    .stButton > button:hover, .stTabs [aria-selected="true"]:hover {
        transform: translateY(-2px) !important;
        box-shadow: 0 6px 20px rgba(0, 114, 255, 0.5) !important;
        filter: brightness(1.1);
    }

    /* Tab List Background */
    .stTabs [data-baseweb="tab-list"] {
        gap: 10px;
        background-color: #f1f5f9;
        padding: 8px;
        border-radius: 15px;
    }

    .stTabs [data-baseweb="tab"] {
        border-radius: 10px;
        padding: 10px 20px;
        transition: color 0.3s ease;
    }
            

    /* Inactive Tabs Hover */
    .stTabs [data-baseweb="tab"]:hover {
        color: #0072ff !important;
    }

    /* Sidebar Styling */
    [data-testid="stSidebar"] {
        background: linear-gradient(180deg, #1e3a8a 0%, #3b82f6 100%);
    }
    
    [data-testid="stSidebar"] * {
        color: white !important;
    }

    /* Cards & Metrics */
    .prediction-card {
        background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
        padding: 2.5rem;
        border-radius: 25px;
        color: white;
        box-shadow: 0 20px 60px rgba(0,0,0,0.15);
    }
    
    .metric-card {
        background: linear-gradient(135deg, #0072ff 0%, #00c6ff 100%);
        padding: 2rem;
        border-radius: 20px;
        color: white;
        text-align: center;
    }

    .info-card {
        background: white;
        padding: 2rem;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        margin: 1rem 0;
        border-left: 5px solid #0072ff;
        transition: transform 0.3s ease;
    }
    
    .info-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 50px rgba(0,0,0,0.12);
    }

    .badge {
        display: inline-block;
        padding: 0.35em 0.9em;
        font-size: 0.75em;
        border-radius: 50px;
        background: rgba(255,255,255,0.2);
        backdrop-filter: blur(10px);
    }
            
        /* Metric Cards */
    .metric-card {
        background: linear-gradient(135deg, #0072ff 0%, #00c6ff 100%);
        padding: 2rem;
        border-radius: 20px;
        color: white;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,114,255,0.2);
        height: 180px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        transition: transform 0.3s ease;
    }
    
    .metric-card:hover {
        transform: translateY(-5px);
    }
    
    .metric-card h4 {
        font-size: 1.1rem;
        margin-bottom: 0.5rem;
        color: rgba(255,255,255,0.9);
        font-weight: 500;
    }
    
    .metric-card .value {
        font-size: 2.5rem;
        font-weight: 700;
        margin: 0.5rem 0;
        color: white;
    }
    
    .metric-card .sub-value {
        font-size: 0.9rem;
        color: rgba(255,255,255,0.8);
    }
    
    /* Badge Styling */
    .badge {
        display: inline-block;
        padding: 0.35em 0.9em;
        font-size: 0.75em;
        font-weight: 600;
        line-height: 1;
        text-align: center;
        white-space: nowrap;
        vertical-align: baseline;
        border-radius: 50px;
        background: rgba(255,255,255,0.2);
        color: white;
        margin: 0 0.2rem;
        backdrop-filter: blur(10px);
    }
    
    /* Input Styling */
    .stSlider {
        margin-top: 0.5rem;
    }
    
    .stNumberInput {
        margin-top: 0.5rem;
    }
    
    /* Progress Bar */
    .stProgress > div > div > div > div {
        background: linear-gradient(90deg, #0072ff, #00c6ff);
        border-radius: 10px;
    }
</style>
""", unsafe_allow_html=True)

# ================================
# 🧠 AI MODEL LOADER
# ================================
MODEL_PATH = "model_pipeline_ols.pkl"

@st.cache_resource(show_spinner=True)
def load_ai_model():
    try:
        # st.spinner('🚀 Loading Model...')
        model = joblib.load(MODEL_PATH)
        return model
    except Exception as e:
        st.error(f'🔴 Error: {str(e)}')
        return None

model = load_ai_model()

# ================================
# 📈 VISUALIZATION FUNCTIONS
# ================================
def create_prediction_gauge(prediction):
    fig = go.Figure(go.Indicator(
        mode="gauge+number",
        value=prediction,
        title={'text': "DAILY TARGET (L)", 'font': {'size': 18}},
        gauge={
            'axis': {'range': [0, 5], 'tickwidth': 1},
            'bar': {'color': "#0072ff"},
            'bgcolor': "white",
            'borderwidth': 2,
            'bordercolor': "#e2e8f0",
            'steps': [
                {'range': [0, 1.5], 'color': 'rgba(239, 68, 68, 0.1)'},
                {'range': [1.5, 3.5], 'color': 'rgba(34, 197, 94, 0.1)'},
            ],
        }
    ))
    fig.update_layout(height=300, margin=dict(l=30, r=30, t=50, b=30))
    return fig

# ================================
# 🎨 SIDEBAR NAVIGATION
# ================================
with st.sidebar:
    # Logo and Title
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.markdown("""
        <div style='text-align: center;'>
            <h1 style='color: white; font-size: 2.5rem; margin-bottom: 0.5rem;'>💧</h1>
            <h2 style='color: white; font-size: 1.5rem; margin-bottom: 0.2rem;'>Smart Water Bottle</h2>
        </div>
        """, unsafe_allow_html=True)
    
    st.markdown("---")
    
    # Navigation
    st.markdown("### 🧭 Navigation")
    page = st.radio(
        "",
        ["📊 Dashboard", "🤖 AI Prediction"],
        label_visibility="collapsed"
    )
    
    st.markdown("---")
    
    # Model Status
    st.markdown("### 🔧 Model Status")
    st.markdown("""
    <div style='background: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;'>
        <p style='color: white; margin-bottom: 0.5rem;'>✅ <strong>Model Loaded</strong></p>
        <p style='color: rgba(255,255,255,0.8); font-size: 0.9rem; margin: 0;'>CatBoost Regressor</p>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown("---")
    
    # Session Info
    st.markdown("### 📊 Session Info")
    st.markdown(f"""
    <div style='background: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;'>
        <p style='color: white; margin-bottom: 0.3rem;'>🕒 {datetime.now().strftime('%H:%M:%S')}</p>
        <p style='color: rgba(255,255,255,0.8); font-size: 0.9rem; margin: 0;'>Session Active</p>
    </div>
    """, unsafe_allow_html=True)

# ================================
# 📊 PAGE 1: DASHBOARD
# ================================
if page == "📊 Dashboard":
    # Header
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.markdown('<h1 class="main-header">💧 SipSmart</h1>', unsafe_allow_html=True)
        st.markdown('<p class="sub-header">Intelligent Hydration Prediction System</p>', unsafe_allow_html=True)
    
    st.markdown("---")
    
    # Model Info Cards
    st.markdown("### 📈 Model Performance Matrics")
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("""
        <div class="metric-card">
            <h4>🧠 Model</h4>
            <div class="value">CatBoost</div>
            <div class="sub-value">Gradient Boosting Algorithm</div>
        </div>
        """, unsafe_allow_html=True)
    
    with col2:
        st.markdown("""
        <div class="metric-card">
            <h4>🎯 Accuracy</h4>
            <div class="value">93.1%</div>
            <div class="sub-value">R² Score</div>
        </div>
        """, unsafe_allow_html=True)
    
    with col3:
        st.markdown("""
        <div class="metric-card">
            <h4>📊 Features</h4>
            <div class="value">4</div>
            <div class="sub-value">Input Parameters</div>
        </div>
        """, unsafe_allow_html=True)
    
    
# ================================
# 🤖 PAGE 2: AI PREDICTION
# ================================
elif page == "🤖 AI Prediction":
    # Header
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.markdown('<h1 class="main-header">🤖 AI Prediction</h1>', unsafe_allow_html=True)
        st.markdown('<p class="sub-header">Get Personalized Water Intake Recommendations</p>', unsafe_allow_html=True)
    
    # Tabs
    tab1, tab2 = st.tabs(["⚙️ Input Features", "📊 Prediction Results"])
    
    with tab1:
        st.markdown("### 🎯 Configure Your Parameters")
        
        col1, col2 = st.columns(2)
        
        with col1:
            
            st.markdown("#### 👤 Personal Information")
            
            Age = st.slider(
                "**Age** (years)",
                min_value=18,
                max_value=80,
                value=30,
                help="Age affects metabolism and hydration needs"
            )
            
            Gender = st.radio(
                "**Gender**",
                options=["Male", "Female"],
                horizontal=True,
                help="Biological differences in hydration requirements"
            )
            
            st.markdown('</div>', unsafe_allow_html=True)
        
        with col2:
            st.markdown("#### 🌡️ Environmental Factors")
            
            Temperature_C = st.slider(
                "**Temperature** (°C)",
                min_value=10.0,
                max_value=50.0,
                value=25.0,
                step=0.5,
                help="Higher temperatures increase water loss"
            )
            
            st.markdown('</div>', unsafe_allow_html=True)
        
        st.markdown("#### 🏃 Activity Level")
        
        Activity_Level = st.select_slider(
            "**Activity Intensity**",
            options=["Low", "Medium", "High"],
            value="Low",
            help="Physical activity level significantly impacts hydration needs"
        )
        
        st.markdown('</div>', unsafe_allow_html=True)

    with tab2:
        col_btn = st.columns([1, 2, 1])
        with col_btn[1]:
            # The Cyan Gradient Button
            predict_btn = st.button("🚀 Prediction", type="primary", use_container_width=True)
        
        if predict_btn and model is not None:
            with st.spinner('🤖 AI is calculating...'):
                time.sleep(1) # Visual effect
                
                # Prepare data
                input_data = pd.DataFrame({
                    "Age": [Age],
                    "Temperature_C": [Temperature_C],
                    "Gender": [Gender],
                    "Activity_Level": [Activity_Level]
                })
                
                # Prediction
                prediction = model.predict(input_data)[0]
                
                
                st.markdown("## 📊 Results")
                res_col1, res_col2 = st.columns([2, 1])
                with res_col1:
                    st.markdown(f"""
                    <div class="prediction-card">
                        <h3>💧 AI RECOMMENDED INTAKE</h3>
                        <h1 style="font-size: 4.5rem; margin: 0.5rem 0;">{prediction:.2f} L</h1>
                    </div>
                    """, unsafe_allow_html=True)
                with res_col2:
                    st.plotly_chart(create_prediction_gauge(prediction), use_container_width=True)

# ================================
# 🎓 FOOTER
# ================================
st.markdown("---")
st.markdown('<p style="text-align: center; color: #64748b; font-size: 0.8rem;">🎓 Graduation Project | Smart Water Bottle AI © 2026</p>', unsafe_allow_html=True)