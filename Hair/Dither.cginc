half _DitherMotion;

void Dither(float2 pos, float alpha)
{
    // https://ocias.com/blog/unity-stipple-transparency-shader/
    //pos +=  (_Time * _DitherMotion, 0);
    //pos.x += _Time * _DitherMotion;
    pos *= _ScreenParams.xy;
    pos.x += _Time.y * _DitherMotion;

    
    float4x4 thresholdMatrix =
    {  1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
      13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
       4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
      16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
    };
    float4x4 _RowAccess = { 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1 };
    clip(alpha - thresholdMatrix[fmod(pos.x, 4)] * _RowAccess[fmod(pos.y, 4)]);
}